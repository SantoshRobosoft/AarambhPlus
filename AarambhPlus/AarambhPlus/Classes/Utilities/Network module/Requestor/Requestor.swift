//
//  Requestor.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import Alamofire
import Foundation
public typealias DataRequestID = String
typealias VoidCompletion = (() -> Void)

public typealias APICompletion<D: Decodable> = ((DataResult<D>) -> Void)
public let sessionExpiryNotificationName = "LoginSessionExpired"

class BaseRequestor {
    let apiResource: APIResource!
    let decoder = JSONDecoder()
    static var sessionManager = SessionManager()
    
    init(resource: APIResource?) {
        self.apiResource = resource
    }
    
    /**
     Creates a `DataRequest` using Alamofire's request method.
     
     - Returns: `DataRequest` created by Alamofire.
     */
    internal func sendRequest() -> DataRequest? {
        let request = BaseRequestor.sessionManager.request(apiResource.urlString,
                                                           method: self.httpMethod,
                                                           parameters: apiResource.parameter,
                                                           encoding: parameterEncodingForAPI(resource: apiResource),
                                                           headers: self.httpHeaders).validate()
        /// Printing it out request details.
        self.printRequestDetails(request, dataParameters: apiResource.parameter)
        return request
    }
    
    /**
     It will create network request to get the data from specified URL
     ## Note ##
     This is a generic requestor method. Here we need to specify data type we requesting for. And in completion block this will return same type of data.
     
     - Retruns: unique data request ID of type `String`
     */
    func sendRequest<T: Decodable>(completion: APICompletion<T>?) -> DataRequestID {
        /// Network connection checking.
        if NetworkSessionManager.shared.isServerReachable {
            guard let request = self.sendRequest() else { return "invalid request" }
            let dataReq = request.response { response in
                
                let validation = self.validate(data: response.data, error: response.error)
                let result: DataResult<T>
                if validation.success, let data = response.data as? T {
                    result = DataResult.success(APIResponse<T>(statusCode: 200, data: data, responseHeaders: response.response?.allHeaderFields, message: "", timeInterval: nil))
                } else {
                    result = DataResult.failure(validation.error ?? APIError.somethingWentWrong)
                }
                completion?(result)
            }
            return self.generateTaskId(forReq: dataReq)
        } else {
            completion?(DataResult.failure(APIError.noInternetConnection))
            return ""
        }
    }
    
    /**
     This will try to renew accessToken by calling token API.
     And in completion it will pass the `APIError` if any.
     - parameter completionhandler: closure to be called after accessToken renewed.
     */
    final func renewAccessToken(completionhandler: @escaping (APIError?) -> Void) {
        RequestManager.shared.isRenewTokenRunning = true
//        AccountsDataManager.renewAccessToken { (error) in
//            RequestManager.shared.isRenewTokenRunning = false
//
//            if let apiError = error, case APIError.sessionExpired = apiError {
//                NotificationCenter.default.post(name: NSNotification.Name(sessionExpiryNotificationName), object: nil)
//                RequestManager.shared.flushRequestQueue()
//            } else {
//                completionhandler(error)
//            }
//        }
    }
    
    final var httpMethod: HTTPMethod {
        return HTTPMethod(rawValue: self.apiResource.method.rawValue) ?? HTTPMethod.get
    }
    
    final var httpHeaders: [String: String]? {
        var headers: [String: String] = [:]
        
        /// Here we add common headers first
        //  self.setPHashForAPIRequest(&headers)
        
        if case .json = self.apiResource.contentType {
            /**
             Alamofire will set Content-Type depending upon ParameterEncoding.
             But for some of our API require application/json but doesn't have request parameter's.
             Alamofire will set content type if request parameters are present. So we are setting content type for json specifically. By default it will be urlencoded only.
             */
            headers["Content-Type"] = "application/json"
        }
        headers["Channel"] = "MOBILE"
        headers["Device-Type"] = iPad ? "IPAD" : "IPHONE"
        // headers["Device-Type"] = "IPHONE"
        return headers
    }
    
    fileprivate var requiredPHashType: PHashInput {
        // If during request itself dtm is mentioned returning dtm.
        guard self.apiResource.pHashInput != .dtm else {
            return .dtm
        }
        // If request is get method then its always dtm based irresptive of parameters.
        guard self.apiResource.method != .get else {
            return .dtm
        }
        // If there is no parameters at all then its dtm based.
        guard let parameters = self.apiResource.parameter, !parameters.isEmpty else {
            return .dtm
        }
        return .requestParams
    }
    
    /**
     This will return Parameter encoding required for Alamofire.
     - parameter resource: API resource.
     - Returns: ParameterEncoding required for API request.
     */
    final func parameterEncodingForAPI(resource: APIResource) -> ParameterEncoding {
        switch resource.contentType {
        case .json:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    /**
     Generates UUID. And saves the URLSessionTask for the generated UUID.
     This UUID string can be used for cancelling the URLSessionTask.
     - parameter req: Alamofire request.
     - Returns: UUID string.
     */
    final func generateTaskId(forReq req: Request) -> String {
        let uniqueId = NSUUID().uuidString
        RequestManager.shared.setTask(req.task, forKey: uniqueId)
        return uniqueId
    }
    
    /**
     Validates the data and error in basic level.
     1. Data should not be nil
     2. There should not be any error.
     
     - parameter data: resposne data
     - parameter error: response error
     - Returns: A *tuple* with success flag and optional APIError
     */
    func validate(data: Any?, error: Error?, responseData: Data? = nil) -> (success: Bool, error: APIError?) {
        /// Here just basic validation checking data is nil or not and error is present.
        var validationError: APIError?
        if error != nil {
            var errorMessage: String?
            var code = (error as NSError?)?.code
            do {
                if let jsonData = responseData {
                    if let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] {
                        errorMessage = jsonResult["message"] as? String
                        if let c = jsonResult["code"] as? Int {
                            code = c
                        }
                        print(jsonResult)
                        print("")
                    }
                }
                let msg = errorMessage ?? (error as NSError?)?.localizedDescription
                if code == 403 {
                   validationError = APIError.accountBlocked(message: msg)
                } else {
                    validationError = APIError.generalError(code: code, message: msg)
                }
                let status = (validationError == nil) ? true : false
                return (status, validationError)
            } catch {
            }
        }
        if data == nil {
            validationError = APIError.invalidResponse
        }
        let status = (validationError == nil) ? true : false
        return (status, validationError)
    }
    
    func printRequestDetails(_ request: Request, dataParameters: Any?) {
        #if DEBUG
        print("===================================================================")
        print("Request: \n")
        print("Method       = ", request.request?.httpMethod ?? "NA")
        print("URL          = ", request.request?.url ?? "NA")
        print("Headers      = ", request.request?.allHTTPHeaderFields ?? "NA")
        print("parameters   = ", dataParameters ?? "NA")
        print("DebugDescription\n")
        print(request.debugDescription)
        print("===================================================================\n\n")
        #endif
    }
    
    func printResponse(_ response: DataResponse<Any>) {
        #if DEBUG
        print("===================================================================")
        print("Response:")
        print("DebugDescription")
        print(response.debugDescription)
        print("===================================================================\n\n")
        #endif
    }
    
    deinit {
        print("Base requestor deinit called")
    }
}

extension BaseRequestor {
    class func request<T: Decodable>(url: String?, contentType: RequestContentType = .json, method: RequestMethod, parameters: [String: Any]? = nil, responseKey: String? = nil, handler: (APICompletion<T>)? = nil) {
        guard let url = url else {
            handler?(DataResult.failure(APIError.invalidRequest))
            return
        }
        let dataReq = DataResource<T>(loadFromServer: { (completion) -> DataRequestID in
            let responseKeyvalue = responseKey
//            if let res = responseKey?.replacingFirstOccurrenceOfString(target: "data.", withString: "") {
//                responseKeyvalue += ".\(res)"
//            }
            var params = parameters
            var urlString = url
            if parameters != nil, method == .get {
                params?["_format"] = "json"
            } else {
                urlString = urlString.contains("?") ? (urlString + "&_format=json") : (urlString + "?_format=json")
            }
            
            let resource = APIResource(URLString: urlString, method: method, parameters: params, contentType: contentType, responseKey: responseKeyvalue)
            return JSONRequestor(resource: resource).sendRequest(completion: completion)
        })
        dataReq.executeWith(completion: handler)
    }
    
    class func getRequest<T: Decodable>(url: String?, parameters: [String: Any]? = nil, responseKey: String? = nil, handler: (APICompletion<T>)? = nil) {
        request(url: url, contentType: .urlEncoded, method: .get, parameters: parameters, responseKey: responseKey, handler: handler)
    }
    
    class func postRequest<T: Decodable>(url: String?, parameters: [String: Any]? = nil, responseKey: String? = nil, handler: (APICompletion<T>)? = nil) {
        request(url: url, method: .post, parameters: parameters, responseKey: responseKey, handler: handler)
    }
    
    class func putRequest<T: Decodable>(url: String?, parameters: [String: Any]? = nil, responseKey: String? = nil, handler: (APICompletion<T>)? = nil) {
        request(url: url, method: .put, parameters: parameters, responseKey: responseKey, handler: handler)
    }
    
    class func patchRequest<T: Decodable>(url: String?, parameters: [String: Any]? = nil, responseKey: String? = nil, handler: (APICompletion<T>)? = nil) {
        request(url: url, method: .patch, parameters: parameters, responseKey: responseKey, handler: handler)
    }
}
