//
//  JSONRequestor.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import Alamofire
import Foundation

class JSONRequestor: BaseRequestor {
    override func sendRequest<T>(completion: ((DataResult<T>) -> Void)?) -> DataRequestID where T: Decodable {
        if NetworkSessionManager.shared.isServerReachable {
            let req = self.sendRequest()?.responseJSON(queue: DispatchQueue.global()) { response in
                
                self.printResponse(response)
                let result: DataResult<T>
                do {
                    
                    let parseResult: APIResponse<T> = try self.parseJSON(response: response)
                    result = DataResult.success(parseResult)
                    completion?(result)
                } catch {
                    let apiError: APIError = (error as? APIError) ?? APIError.somethingWentWrong
                    result = DataResult.failure(apiError)
                    
                    ///First we check for expired accessToken
                    if case APIError.invalidAccessToken = apiError {
                        /**
                         If accesstoken is invalid then we check for token renewal state.is in progress?
                         1. If token renewal is in progress, then in completion we pass special error `.needRetry`.
                         Our 'DataResource' class will handle the request retrying upon accessToken renewal.
                         2. If there is no token renewal running. we will call token renewal function.
                         */
                        if !RequestManager.shared.isRenewTokenRunning {
                            self.handleAccessTokenRenewal(completion: completion)
                        } else {
                            completion?(DataResult.failure(APIError.needRetry))
                        }
                    } else if case APIError.sessionExpired = apiError {
                        /**
                         1. If error is session expiry. then we post session expiry notification. Our AppCoordinator will observe for this, and handle the session expiry.
                         2. Also check for the request of sessionExpiry in completion. If it required we pass session expiry error in completion.
                         */
                        NotificationCenter.default.post(name: NSNotification.Name(sessionExpiryNotificationName), object: nil)
                        if let shouldReturn = self.apiResource?.shouldReturnSessionExpiry, shouldReturn {
                            completion?(result)
                        }
                    } else if case APIError.accountBlocked = apiError {
                        completion?(DataResult.failure(apiError))
                        //                        UserManager.shared.signOut()
                    } else {
                        ///Any other error we pass in completion.
                        completion?(result)
                    }
                }
            }
            return self.generateTaskId(forReq: req!)
        } else {
            completion?(DataResult.failure(APIError.noInternetConnection))
            return ""
        }
    }
    
    /**
     This validates the data and error with respect to JSON format.
     1. Data should not be nil
     2. Data should be a `Dictionary`.
     3. There should not be a sessionExpiry, invalidAccessToken, or invalidRequest status codes.
     4. There should not be any error.
     
     - parameter data: resposne data
     - parameter error: response error
     - Returns: A *tuple* with success flag and optional APIError
     */
    override func validate(data: Any?, error: Error?, responseData: Data? ) -> (success: Bool, error: APIError?) {
        let validation = super.validate(data: data, error: error, responseData: responseData)
        
        guard validation.success, validation.error == nil else {
            return validation
        }
        
        //Some JSON specific validation here
        let json = data as? JSONDictionary
        let jsonArray = data as? [Any]
        if  json == nil && jsonArray == nil {
            //Not a json dictionary/ Array
            return (false, APIError.invalidResponse)
        }
        if let json = json {
            var status: Int = 200
            if let cd = json["code"] as? Int {
                status = cd
            } else if let cdStr = json["code"] as? String, let cd = Int(cdStr) {
                status = cd
            }
            print(status)
            guard status != APIStatusCode.loginFailedErrorCode.rawValue else {
                //invalid access token
                return (false, APIError.loginFailed(message: json["msg"] as? String))
            }
            guard status != APIStatusCode.signUpFailedErrorCode.rawValue else {
                //invalid access token
                return (false, APIError.loginFailed(message: json["msg"] as? String))
            }
            guard status != APIStatusCode.invalidAccessToken.rawValue else {
                //invalid access token
                return (false, APIError.invalidAccessToken)
            }
            
            guard status != APIStatusCode.sessionExpired.rawValue else {
                //invalid session
                return (false, APIError.sessionExpired)
            }
            
            guard status != APIStatusCode.invalidRequest.rawValue else {
                //request is invalid
                return (false, APIError.invalidRequest)
            }
            
            guard status == APIStatusCode.success.rawValue else {
                //request is invalid
                let message =  (json["msg"] as? String) ?? "We are sorry try after some time."
                return (false, APIError.generalError(code: status, message: message))
            }
            if let respkey = self.apiResource?.responseKeyPath {
                guard getKeyPathResult(keypath: respkey, json: json)  != nil else {
                    //data missing at required key path
                    return (false, APIError.invalidResponse)
                }
            }
        }
        
        return (true, nil)
    }
    
    func getKeyPathResult(keypath:String, json: Any) -> Any? {
        let keys = keypath.components(separatedBy: ".")
        var jsonDict: Any = json
        for key  in keys {
            if let dict = (jsonDict as? [String:Any]),let info = dict[key] {
                jsonDict = info
            } else {
                return nil
            }
        }
        return jsonDict
    }
    
    /**
     Creates the Model by parsing the response JSON.
     If there is any validation error or decoding error `APIError` is thrown.
     
     - Returns: `APIResponse` encapsulating the status code, data model & response headers.
     */
    func parseJSON<T: Decodable>(response: DataResponse<Any>) throws -> APIResponse<T> {
        var parsedModel: APIResponse<T>
        
        let validation = self.validate(data: response.value, error: response.error, responseData: response.data)
        guard validation.success, validation.error == nil else {
            //return (nil, validation.error)
            throw validation.error!
        }
        var json = response.value!
        
        var statusCode = NSNotFound
        var message = ""
        var timeInterval:TimeInterval = Date().timeIntervalSince1970
        
        if nil != json as? JSONDictionary {
            ///Getting status code from the response.
            if let sCode = (json as AnyObject).value(forKeyPath: "code") as? Int {
                statusCode = sCode
            } else if let codeStr = (json as AnyObject).value(forKeyPath: "code") as? String, let sCode = Int(codeStr) {
                statusCode = sCode
            }
            if let mes = (json as AnyObject).value(forKeyPath: "message") as? String {
                message = mes
            }
            if let time = (json as AnyObject).value(forKeyPath: "time") as? TimeInterval {
                timeInterval = time
            }
            
            ///Getting the data from required key paths
            if let keyPath = self.apiResource?.responseKeyPath, let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) {
                json = nestedJson
            }
        } else {
            statusCode = 200
            
        }
        guard type(of: json) != NSNull.self else {
            //return (nil, validation.error)
            throw APIError.parsingError
        }
        
        let headers = response.response?.allHeaderFields
        
        if T.self == CODE.self {
            ///If API is requested just to return status code. we don't do decoding.
            parsedModel = APIResponse<T>(statusCode: statusCode, data: nil, responseHeaders: headers, message: message, timeInterval:timeInterval)
        } else {
            var obj: T?, parseError: APIError?
            do {
                let data = try JSONSerialization.data(withJSONObject: json)
                ///Actual model creation happens here.
                obj = try self.decoder.decode(T.self, from: data)
            } catch {
                debugPrint(error)
                ///Some decoding error occured.
                parseError = APIError.parsingError
            }
            
            ///Some API returns just status code in some scenarios.
            ///to handle that we check for parsed object and status code.
            if obj == nil, statusCode != NSNotFound {
                ///If object is nil and contain valid status code. then we need to pass success response in completion.
                parsedModel = APIResponse<T>(statusCode: statusCode, data: nil, responseHeaders: headers, message: message, timeInterval: timeInterval)
            } else if let model = obj {
                parsedModel = APIResponse<T>(statusCode: statusCode, data: model, responseHeaders: headers, message: message, timeInterval: timeInterval)
            } else {
                //throwing parse error
                throw parseError ?? APIError.parsingError
            }
        }
        return parsedModel
    }
    
    /**
     Handles token renewal. Once token gets renewed it will repeat the API request
     */
    func handleAccessTokenRenewal<T>(completion: APICompletion<T>?) where T: Decodable {
        self.renewAccessToken { error in
            if let apiErr = error {
                completion?(DataResult.failure(apiErr))
                RequestManager.shared.clearPendingRequestQueue()
            } else {
                _ = self.sendRequest(completion: completion)
                RequestManager.shared.executePendingDataResourceRequests()
            }
        }
    }
}
