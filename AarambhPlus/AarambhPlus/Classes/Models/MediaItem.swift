//
//  MediaItem.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/8/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit


class MediaItem: NSObject, Codable {

    var artistName: String?
    var id: String?
    var name: String?
    var image: String?
    var uniq_id: String?
    
    enum CodingKeys: String, CodingKey {
        case artistName, name, uniq_id
        case image = "poster"
        case id = "movie_id"
    }
}

extension MediaItem: LayoutProtocol {
    
    func getTitle() -> String? {
        return name
    }
    
    func getImageUrl() -> String? {
        return image
    }
}
