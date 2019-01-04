//
//  Layout.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/8/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class Layout: NSObject, Codable {

    var title: String?
    var mediaItems: [MediaItem]?
    var id: String?
    
    //not from response
    var layoutType: LayoutType = .row_Item
    
    enum CodingKeys: String, CodingKey {
        case title, id
        case mediaItems = "contents"
    }
}

extension Layout: TopBannerProtocol {
    func getItem() -> [LayoutProtocol] {
        return mediaItems ?? []
    }
    
    func getItemType() -> LayoutType? {
//        if let layout = layOut {
//            return LayoutType(rawValue: layout)
//        }
        return .row_Item
    }
    
    func getTitle() -> String? {
        return title
    }
}
