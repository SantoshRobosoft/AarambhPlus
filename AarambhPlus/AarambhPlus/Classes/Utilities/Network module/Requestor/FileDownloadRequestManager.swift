//
//  FileDownloadRequestManager.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import Foundation
import Alamofire

class FileDownloadRequestor: JSONRequestor {
    func downloadFile(fileName: String, progressResponse: ((Progress?) -> Void)? = nil, completion: ((Any?, Error?) -> Void)?) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(fileName)
            return (documentsURL, [.removePreviousFile])
        }
        
        BaseRequestor.sessionManager.download(apiResource.urlString, to: destination).downloadProgress(closure: { (progress) in
            print(progress)
            progressResponse?(progress)
        })
            .responseData { (response) in
            if let error = response.error {
                completion?(nil, error)
            } else if let destinationURL = response.destinationURL {
                completion?(destinationURL, nil)
            } else {
                completion?(nil, nil)
            }
            
        }
    }
}
