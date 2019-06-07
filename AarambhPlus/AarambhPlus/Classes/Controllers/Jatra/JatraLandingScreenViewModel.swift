//
//  JatraLandingScreenViewModel.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 19/04/19.
//  Copyright © 2019 Santosh Dev. All rights reserved.
//


protocol GridViewModelProtocol {
    var stopFetchingContent: Bool { get set }
    var mediaItems: [MediaItem] { get set }
    var pageOffset: Int { get set}
    var itemsPerPage: Int { get set}
    func fetchItems(limit: Int, completionHandler handler: @escaping ((Bool,Error?)->Void))
    func numberOfItemsInSection() -> Int
    
}

class JatraLandingScreenViewModel: GridBaseViewModel {
    
    
    
    
}

class GridBaseViewModel: NSObject, GridViewModelProtocol {
    
    var pageOffset: Int = 0
    var mediaItems: [MediaItem] = []
    var refreshAfterFetch: ((Bool,Error?)->Void)?
    var itemsPerPage: Int = 10
    var stopFetchingContent = false
    
    func fetchItems(limit: Int, completionHandler handler: @escaping ((Bool, Error?) -> Void)) {
        guard !stopFetchingContent, let url = RestApis.tabUrl() else {
            handler(false, nil)
            return
        }
        
        let urlStr = "\(url)&limit=\(itemsPerPage)&offset=\(pageOffset)"
        pageOffset += 1
        NetworkManager.fetchContentFor(parameters: nil, url: urlStr) {[weak self] (data) in
            if let layout = data.response?.data?.mediaItems {
                if layout.isEmpty {
                    self?.stopFetchingContent = true
                } else {
                    self?.mediaItems.append(contentsOf: layout)
                }
                handler(true, nil)
            } else {
                handler(false, nil)
            }
        }
    }
    
    func numberOfItemsInSection() -> Int {
        return mediaItems.count
    }
}

