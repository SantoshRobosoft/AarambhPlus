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
    var isSubscribed: String?
    
    enum CodingKeys: String, CodingKey {
        case id, email, isFree, isSubscribed
        case displayName = "display_name"
        case nickName = "nick_name"
        case studioId = "studio_id"
    }
    
}
