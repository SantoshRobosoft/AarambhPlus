//
//  JatraLandingScreenViewModel.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 19/04/19.
//  Copyright © 2019 Santosh Dev. All rights reserved.
//


class JatraLandingScreenViewModel: NSObject {
    
    private(set) var jatras = [MediaItem]()
    var refreshAfterFetch: ((Bool,Error?)->Void)?
    private(set) var offset: Int = 0
    private var stopFetchingContent = false
    
    func fetchJatraList(limit: Int, completionHandler handler: ((Bool,Error?)->Void)?) {
        guard !stopFetchingContent, let url = RestApis.tabUrl() else {
            handler?(false, nil)
            return
        }
        
        let urlStr = "\(url)&limit=\(limit)&offset=\(offset)"
        offset += 1
        NetworkManager.fetchContentFor(parameters: nil, url: urlStr) {[weak self] (data) in
            if let layout = data.response?.data?.mediaItems {
                if layout.isEmpty {
                    self?.stopFetchingContent = true
                } else {
                    self?.jatras.append(contentsOf: layout)
                }
                handler?(true, nil)
            } else {
                handler?(false, nil)
            }
        }
    }
    
    
}

extension JatraLandingScreenViewModel {
    
    func numberOfItemsInSection() -> Int {
        return jatras.count
    }
}
