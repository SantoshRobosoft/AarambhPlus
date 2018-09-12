//
//  RestApis.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/11/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import Foundation

var baseURL = "https://www.muvi.com/rest"
var kAuthToken = "5cb50718d78a0473a5b2fdb9f1998bbc"

class RestApis {
    
    static let shared = RestApis()
    private init() { }
    
    var loginUrl = "\(baseURL)/login"
    var signUpUrl = "\(baseURL)/registerUser"
    var bannerUrl = "\(baseURL)/"
    var userInfoUrl = "\(baseURL)/GetProfileDetails"
    var logOutUrl = "\(baseURL)/logout"
}
