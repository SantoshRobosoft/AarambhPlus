//
//  MultipartUploadRequestor.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import Alamofire
import Foundation

class MultipartUploadRequestor: JSONRequestor {
    /**
     Multipart API requestor. It will create and execute the multipart upload request.
     - parameter progress: Closure to be called for progress indication.
     - parameter completion; Closure to be called once API request finishes.
     
     - Returns: Unique data request ID of type `String`
    */
    func sendMultipartRequest<T>(progress: ((Progress) -> Void)? = nil, completion: ((DataResult<T>) -> Void)?) -> DataRequestID where T: Decodable {
        if NetworkSessionManager.shared.isServerReachable {
            ///First we create once unique id.
            ///In multipart we receive URLSessionTask in encoding completion. But we need to return request id at the end.
            ///So we create task ID and return it but later we map the session task with this id.
            let taskId = NSUUID().uuidString
            BaseRequestor.sessionManager.upload(multipartFormData: { formData in
                //set the form data
                if let data = self.apiResource.formData {
                    self.appendData(data, toMultipartFormData: formData)
                }
            }, to: apiResource.urlString,
            method: self.httpMethod,
            headers: self.httpHeaders, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let uploadRequest, _, _):
                    self.printRequestDetails(uploadRequest, dataParameters: self.apiResource.formData)
                    ///Mapping URLSessionTask with unique task ID string.
                    RequestManager.shared.setTask(uploadRequest.task, forKey: taskId)
                    RequestManager.shared.setRequest(uploadRequest, forKey: taskId)
                    if let progressHandler = progress {
                        ///Setting the progress block to upload request.
                        uploadRequest.uploadProgress(closure: progressHandler)
                    }
                    uploadRequest.responseJSON(queue: DispatchQueue.global(), completionHandler: { response in
                        
                        self.printResponse(response)
                        let result: DataResult<T>
                        do {
                            let parseResult: APIResponse<T> = try self.parseJSON(response: response)
                            completion?(DataResult.success(parseResult))
                        } catch {
                            let parseError: APIError = (error as? APIError) ?? APIError.somethingWentWrong
                            result = DataResult.failure(parseError)
                            
                            ///First we check for expired accessToken
                            if case APIError.invalidAccessToken = parseError {
                                /**
                                 If accesstoken is invalid then we check for token renewal state.is in progress?
                                 1. If token renewal is in progress, then in completion we pass special error `.needRetry`.
                                    Our 'DataResource' class will handle the request retrying upon accessToken renewal.
                                 2. If there is no token renewal running. we will call token renewal function.
                                 */
                                if !RequestManager.shared.isRenewTokenRunning {
                                    self.handleAccessTokenRenewal(progress: progress, completion: completion)
                                } else {
                                    completion?(DataResult.failure(APIError.needRetry))
                                }
                            } else if case APIError.sessionExpired = parseError {
                                /**
                                 1. If error is session expiry. then we post session expiry notification. Our AppCoordinator will observe for this, and handle the session expiry.
                                 2. Also check for the request of sessionExpiry in completion. If it required we pass session expiry error in completion.
                                 */
                                NotificationCenter.default.post(name: NSNotification.Name(sessionExpiryNotificationName), object: nil)
                                if let shouldReturn = self.apiResource?.shouldReturnSessionExpiry, shouldReturn {
                                    completion?(result)
                                }
                            } else {
                                ///Any other error we pass in completion.
                                completion?(result)
                            }
                        }
                    })
                case .failure(let error):
                    ///Failed to upload request
                    completion?(DataResult.failure(APIError.generalError(code: (error as NSError).code, message: (error as NSError).localizedDescription)))
                }
            })
            return taskId
        } else {
            completion?(DataResult.failure(APIError.noInternetConnection))
            return ""
        }
    }
    
    /**
     Appends the request parameters and attachment data to `MultipartFormData`
     
     - parameter input: `APIResource.FormData` API request data.
     - parameter toMultipartFormData: `MultipartFormData` form data to which data needs to be added.
    */
    private func appendData(_ input: APIResource.FormData, toMultipartFormData: MultipartFormData) {
        //first appending attachment data e.g. image data
        if let fileDataList = input.fileAttachments {
            for fileData in fileDataList {
                if let data = fileData.data, let fname = fileData.fileName, let mime = fileData.mimeType {
                    toMultipartFormData.append(data, withName: fileData.keyName, fileName: fname, mimeType: mime)
                }
            }
        }
        //Rest of the request parameters.
        if let otherParameter = input.otherParameter {
            for (keyname, value) in otherParameter {
                toMultipartFormData.append(value, withName: keyname)
            }
        }
    }
    
    /**
     Handles token renewal. Once token gets renewed it will repeat the multipart request
     */
    func handleAccessTokenRenewal<T>(progress: ((Progress) -> Void)? = nil, completion: ((DataResult<T>) -> Void)?) where T: Decodable {
        self.renewAccessToken { error in
            if let apiErr = error {
                completion?(DataResult.failure(apiErr))
                RequestManager.shared.clearPendingRequestQueue()
            } else {
                _ = self.sendMultipartRequest(progress: progress, completion: completion)
                RequestManager.shared.executePendingDataResourceRequests()
            }
        }
    }
}
