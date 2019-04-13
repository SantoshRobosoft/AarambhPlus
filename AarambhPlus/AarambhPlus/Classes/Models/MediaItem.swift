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
    private var c_permalink: String?
    private var permalink: String?
    
    private enum CodingKeys: String, CodingKey {
        case artistName, uniq_id, title, name, poster_url, c_permalink, permalink
        case image = "poster"
        case id = "movie_id"
    }
}

class AudioItem: MediaItem {
    var embeddedUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case embeddedUrl
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.embeddedUrl = try container.decode(String.self, forKey: .embeddedUrl)
        try super.init(from: decoder)
    }
}

extension MediaItem: LayoutProtocol {
    
    @objc func getTitle() -> String? {
        return name ?? title
    }
    
    @objc func getImageUrl() -> String? {
        return image ?? poster_url
    }
    @objc func getPermLink() -> String? {
        return c_permalink ?? permalink
    }
}

extension AudioItem: AudioDatasource {
    func titleString() -> String? {
        return nil
    }
    
    func imageUrl() -> String? {
        return nil
    }
    
    func mediaUrl() -> String? {
        return embeddedUrl
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
    
    override func getPermLink() -> String? {
        return nil
    }
}
