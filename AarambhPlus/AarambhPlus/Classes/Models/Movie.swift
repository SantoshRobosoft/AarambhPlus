//
//  Movie.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 1/10/19.
//  Copyright © 2019 Santosh Dev. All rights reserved.
//

import UIKit

class Movie: NSObject, Codable {
    var id: String?
    var name: String?
    var content_types_id: String?
    var movie_stream_id: String?
    var content_publish_date: String?
    var movie_stream_uniq_id: String?
    var muvi_uniq_id: String?
    var permalink: String?
    var start_time: String?
    var end_time: String?
    var actor: String?
    var director: String?
    var poster: String?
    var movieUrlForTv: String?
    var video_duration: String?
    var content_language: String?
}

extension Movie: AudioDatasource {
    func titleString() -> String? {
        return name
    }
    
    func imageUrl() -> String? {
        return poster
    }
    
    func mediaUrl() -> String? {
        return movieUrlForTv
    }
    
}
