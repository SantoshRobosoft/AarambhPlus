//
//  RestApis.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/11/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import Foundation

var baseURL = "https://www.muvi.com/rest"
var kAuthToken = "8065218b2bb9809a2f4c0f9be7d01cdd"

class RestApis {
    
    static let shared = RestApis()
    private init() { }
    
    var loginUrl = "\(baseURL)/login"
    var signUpUrl = "\(baseURL)/registerUser"
    var bannerUrl = "\(baseURL)/"
    var userInfoUrl = "\(baseURL)/GetProfileDetails"
    var logOutUrl = "\(baseURL)/logout"
}
