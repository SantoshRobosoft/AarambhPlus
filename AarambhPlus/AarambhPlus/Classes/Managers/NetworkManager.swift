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
        BaseRequestor.getRequest(url: "https://www.muvi.com/rest/loadFeaturedSections?authToken=\(kAuthToken)", parameters: parameters, responseKey: "section", handler: handler)
    }
    
    class func loginWith(email: String, password: String, handler: (APICompletion<User>)? = nil) {
        var param = [String:Any]()
        param["email"] = email
        param["password"] = password
        param["authToken"] = kAuthToken
        BaseRequestor.postRequest(url: RestApis.shared.loginUrl, parameters: param, handler: handler)
    }
    
    class func getUserInfo(email: String, userId: String, handler: (APICompletion<User>)? = nil) {
        var param = [String:Any]()
        param["email"] = email
        param["user_id"] = userId
        param["authToken"] = kAuthToken
        BaseRequestor.postRequest(url: RestApis.shared.userInfoUrl, parameters: param, handler: handler)
    }
    
    class func signOut(user: User, handler: (APICompletion<CODE>)? = nil) {
        var param = [String:Any]()
        param["email"] = user.email
        param["login_history_id"] = user.loginHistoryId ?? user.id
        param["authToken"] = kAuthToken
        BaseRequestor.postRequest(url: RestApis.shared.logOutUrl, parameters: param, handler: handler)
    }
    
    class func registerUser(param: [String:Any], handler: (APICompletion<User>)? = nil) {
        BaseRequestor.postRequest(url: RestApis.shared.signUpUrl, parameters: param , handler: handler)
    }
    
}
