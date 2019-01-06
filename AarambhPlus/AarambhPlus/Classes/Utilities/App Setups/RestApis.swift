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

enum RestApis {
    
//    static let shared = RestApis()
//    private init() { }
    
    static let loginUrl = "\(baseURL)/login"
    static let signUpUrl = "\(baseURL)/registerUser"
    static let bannerUrl = "\(baseURL)/homePage"
    static let homeContent = "\(baseURL)/loadFeaturedSections"
    static let userInfoUrl = "\(baseURL)/GetProfileDetails"
    static let logOutUrl = "\(baseURL)/logout"
}
