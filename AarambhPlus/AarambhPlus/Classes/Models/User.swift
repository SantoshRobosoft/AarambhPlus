//
//  User.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class User: NSObject, Codable {

    var id: String?
    var email: String?
    var displayName: String?
    var nickName: String?
    var studioId: String?
    var isFree: String?
    var isSubscribed: Int?
    var loginHistoryId: String?
    var profilePic: String?
    
    enum CodingKeys: String, CodingKey {
        case id, email, isFree, isSubscribed
        case displayName = "display_name"
        case nickName = "nick_name"
        case studioId = "studio_id"
        case loginHistoryId = "login_history_id"
        case profilePic = "profile_image"
    }
    
}
