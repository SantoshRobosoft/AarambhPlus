//
//  NetworkManager.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/8/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {

    class func fetchHomePageDetails(parameters: [String: Any]?, handler: (APICompletion<[Layout]>)? = nil) {
        BaseRequestor.getRequest(url: "https://dl.dropboxusercontent.com/s/fwtkowaasfk52cs/videoApi.json?dl=0", parameters: parameters, responseKey: "lay_outs", handler: handler)
    }
}
