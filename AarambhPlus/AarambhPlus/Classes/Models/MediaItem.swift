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
    var title: String?
    var poster_url: String?
    
    private enum CodingKeys: String, CodingKey {
        case artistName, uniq_id, title, name, poster_url
        case image = "poster"
        case id = "movie_id"
    }
}

extension MediaItem: LayoutProtocol {
    
    @objc func getTitle() -> String? {
        return name ?? title
    }
    
    @objc func getImageUrl() -> String? {
        return image ?? poster_url
    }
}

class Banner: MediaItem {
    
    var url: String?
    
    var layoutType: LayoutType = .top_Banner
    
    private enum CodingKeys: String, CodingKey {
        case url = "mobile_view"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(String.self, forKey: .url)
        try super.init(from: decoder)
    }
    
}

extension Banner {
    
    override func getTitle() -> String? {
        return nil
    }
    
    override func getImageUrl() -> String? {
        return url
    }
    
}
