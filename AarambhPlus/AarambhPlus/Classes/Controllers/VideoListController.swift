//
//  VideoListController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/10/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class VideoListController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var layout: Layout?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "RowItemCell", bundle: nil) , forCellWithReuseIdentifier: "RowItemCell")
        getFavList()
    }

    class func controller() -> VideoListController {
        return UIStoryboard(name: "HomeScreen", bundle: nil).instantiateViewController(withIdentifier: "\(VideoListController.self)") as! VideoListController
    }
}

extension VideoListController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layout?.mediaItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RowItemCell", for: indexPath) as! RowItemCell
        cell.configureCell(dataSource: layout?.mediaItems?[indexPath.row])
        return cell
    }
}

extension VideoListController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (windowWidth - 30)/2, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loadVideoPlayer(layout?._mediaItems?[indexPath.row])
    }
}

private extension VideoListController {
    
    func getFavList() {
        CustomLoader.addLoaderOn(view, gradient: false)
        NetworkManager.getFavoriteList {[weak self] (response) in
            CustomLoader.removeLoaderFrom(self?.view)
            if let layout = self?.parseError(response)?.data {
                self?.layout = layout
                self?.collectionView.reloadData()
            }
        }
    }
    
    func loadVideoPlayer(_ model: Any?) {
        guard let permLink = (model as? MediaItem)?.getPermLink() else {
            showAlertView("Error!", message: "No permlink found.")
            return
        }
        let controller = VideoDetailController.controller(permLink)
        navigationController?.pushViewController(controller, animated: true)
    }
}
