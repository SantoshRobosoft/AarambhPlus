//
//  AttachmentRequestor.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import Foundation

class AttachmentRequestor: BaseRequestor {
    init(path: String) {
        let res = APIResource(URLString: path, method: RequestMethod.get, pHashFrom: PHashInput.dtm)
        super.init(resource: res)
    }
    
    func creatRequest() -> URLRequest? {
        guard let url = URL(string: self.apiResource.urlString) else { return nil }
        
        var urlrequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 180.0)
        if let headers = self.httpHeaders {
            for (key, value) in headers {
                urlrequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        urlrequest.setValue("true", forHTTPHeaderField: "HttpOnly")
        return urlrequest
    }
}
