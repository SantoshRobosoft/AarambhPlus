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
    var releaseDate: String?
    var copyright: String?
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case artistName, id, name, releaseDate, copyright
        case image = "artworkUrl100"
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
