//
//  NetworkManager.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/8/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {

    class func fetchHomePageDetails(parameters: [String: Any]?, url: String, handler: (APICompletion<[Layout]>)? = nil) {
        BaseRequestor.getRequest(url: url, parameters: parameters, responseKey: "section", handler: handler)
    }
    //Fetch Banners
    class func fetchBannerContent(parameters: [String: Any]?, handler: (APICompletion<[Banner]>)? = nil) {
        BaseRequestor.postRequest(url: "\(RestApis.bannerUrl)?authToken=\(kAuthToken)" , parameters: parameters, responseKey: "BannerSectionList.banners", handler: handler)
    }
    
    class func loginWith(email: String, password: String, handler: (APICompletion<User>)? = nil) {
        var param = [String:Any]()
        param["email"] = email
        param["password"] = password
        param["authToken"] = kAuthToken
        BaseRequestor.postRequest(url: RestApis.loginUrl, parameters: param, handler: handler)
    }
    
    class func getUserInfo(email: String, userId: String, handler: (APICompletion<User>)? = nil) {
        var param = [String:Any]()
        param["email"] = email
        param["user_id"] = userId
        param["authToken"] = kAuthToken
        BaseRequestor.postRequest(url: RestApis.userInfoUrl, parameters: param, handler: handler)
    }
    
    class func signOut(user: User, handler: (APICompletion<CODE>)? = nil) {
        var param = [String:Any]()
        param["email"] = user.email
        param["login_history_id"] = user.loginHistoryId ?? user.id
        param["authToken"] = kAuthToken
        BaseRequestor.postRequest(url: RestApis.logOutUrl, parameters: param, handler: handler)
    }
    class func forgotPassword(email: String, handler: (APICompletion<User>)? = nil) {
        var param = [String:Any]()
        param["email"] = email
        param["authToken"] = kAuthToken
        BaseRequestor.postRequest(url: RestApis.forgotPasswordUrl, parameters: param, handler: handler)
    }
    class func resetpassword(password: String, handler: (APICompletion<User>)? = nil) {
        var param = [String:Any]()
        param["password"] = password
        param["user_id"] = UserManager.shared.user?.id
        param["authToken"] = kAuthToken
        BaseRequestor.postRequest(url: RestApis.restPasswordUrl, parameters: param, handler: handler)
    }
    class func registerUser(param: [String:Any], handler: (APICompletion<User>)? = nil) {
        BaseRequestor.postRequest(url: RestApis.signUpUrl, parameters: param , handler: handler)
    }
    
    class func fetchContentFor(parameters: [String:Any]?, url: String, handler: APICompletion<Layout>?) {
        BaseRequestor.getRequest(url: url, parameters: parameters, responseKey: nil, handler: handler)
    }
    
    class func fetchMovieDetail(paramLink: String, handler: APICompletion<Movie>?) {
        let urlStr = "\(RestApis.movieDetailUrl)?authToken=\(kAuthToken)&permalink=\(paramLink)"
        BaseRequestor.getRequest(url: urlStr, parameters: nil, responseKey: "movie", handler: handler)
    }
    
    class func addToFavoriteList(param: [String:Any], handler: (APICompletion<APIStatus>)? = nil) {
        BaseRequestor.postRequest(url: RestApis.addToFavUrl, parameters: param , handler: handler)
    }
    
    class func getFavoriteList(handler: (APICompletion<Layout>)? = nil) {
        var param = [String:Any]()
        param["user_id"] = UserManager.shared.user?.id
        param["authToken"] = kAuthToken
        BaseRequestor.postRequest(url: RestApis.viewFavUrl, parameters: param , handler: handler)
    }
    
    class func getInfoForSearchedString(_ str: String, handler: APICompletion<[MediaItem]>?) {
        let urlStr = "\(RestApis.searchUrl)?authToken=\(kAuthToken)&q=\(str)"
        BaseRequestor.getRequest(url: urlStr, parameters: nil, responseKey: "search", handler: handler)
    }
    
    class func getAudioList(url: String, handler: APICompletion<[AudioItem]>?) {
        
        BaseRequestor.getRequest(url: url, parameters: nil, responseKey: "movieList", handler: handler)
    }
    
    class func getVideoList(url: String, handler: APICompletion<[AudioItem]>?) {
        BaseRequestor.getRequest(url: url, parameters: nil, responseKey: "movieList", handler: handler)
    }
}
