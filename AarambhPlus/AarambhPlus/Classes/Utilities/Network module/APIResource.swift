//
//  APIResource.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import Foundation

public enum RequestMethod: String {
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
    case patch = "PATCH"
}

public enum RequestContentType {
    case json
    case urlEncoded
    case multipart
}

public enum PHashInput {
    case dtm
    case requestParams
}

struct APIResource {
    /// Full URL string
    let urlString: String
    let method: RequestMethod
    let contentType: RequestContentType
    let parameter: [String: Any]?
    let customHeader: [String: String]?
    /// By default for every API response json will be parsed from root level. If we need to parse response from any child items we can specify here.
    let responseKeyPath: String?
    let formData: FormData?
    /// If session gets expired, it will be handled in base level. If we require it in completion block, set this flag. Currently being used for touch/face ID login.
    var shouldReturnSessionExpiry: Bool = false
    let pHashInput: PHashInput

    /**
     API Resource constructor.
     - parameter url: Complete URL string.
     - parameter method: request method of type RequestMethod. By default method will be .get
     - parameter parameters: request parameters. For get method this be passes as URL parameters, for post & put this will be passed as body paramaters. Default is nil.
     - parameter headers: Any specific headers required for the API. **No need to pass common headers.**.
     - parameter contentType: content type of type RequestContentType. This value will be set for the header field **Content-Type**. Default value is .urlEncoded
     - parameter formData: body parameters for multipart request.
     - parameter responseKey: Key path in the response json to be considered for parsing. By default response json will be parsed from root level.

     */
    init(URLString url: String, method: RequestMethod = .get,
         parameters: [String: Any]? = nil, headers: [String: String]? = nil,
         contentType: RequestContentType = .urlEncoded, formData: FormData? = nil, pHashFrom: PHashInput = PHashInput.requestParams, responseKey: String? = nil) {
        self.urlString = url
        self.method = method
        self.contentType = contentType
        self.parameter = parameters
        self.customHeader = headers
        self.responseKeyPath = responseKey
        self.formData = formData
        self.pHashInput = pHashFrom
    }

    /// Form data structure
    struct FormData {
        struct FileAttachment {
            let data: Data?
            let keyName: String
            let fileName: String?
            let mimeType: String?
        }

        let fileAttachments: [FileAttachment]?
        let otherParameter: [String: Data]?
    }
}
