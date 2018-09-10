//
//  TopBannerCell.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/8/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

protocol TopBannerProtocol: class {
    func getItem() -> [LayoutProtocol]
    func getItemType() -> LayoutType?
    func getTitle() -> String?
}

protocol LayoutProtocol: class {
    func getTitle() -> String?
    func getImageUrl() -> String?
}

class TopBannerCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: TopBannerProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "BannerImageCell", bundle: nil), forCellWithReuseIdentifier: "BannerImageCell")
        collectionView.register(UINib(nibName: "RowItemCell", bundle: nil) , forCellWithReuseIdentifier: "RowItemCell")
    }
    
    func configureCell(info: TopBannerProtocol?) {
        dataSource = info
        collectionViewSetup()
        collectionView.reloadData()
    }
}

extension TopBannerCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.getItem().count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let layOutType = dataSource?.getItemType() {
            switch layOutType {
            case .top_Banner, .small_Carousel:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerImageCell", for: indexPath) as! BannerImageCell
                cell.updateUI(dataSource: dataSource?.getItem()[indexPath.row])
                return cell
            case .row_Item:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RowItemCell", for: indexPath) as! RowItemCell
                cell.configureCell(dataSource: dataSource?.getItem()[indexPath.row])
                return cell
            case .nXn_Grid:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RowItemCell", for: indexPath) as! RowItemCell
                cell.configureCell(dataSource: dataSource?.getItem()[indexPath.row])
                return cell
            }
        }
        return UICollectionViewCell()
        
    }
}

extension TopBannerCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layOut = dataSource?.getItemType() {
            switch layOut {
            case .top_Banner:
                return CGSize(width: windowWidth, height: 220)
            case .row_Item:
                return CGSize(width: (windowWidth - 100)/2, height: 200)
            case .small_Carousel:
                return CGSize(width: windowWidth/2 , height: 100)
            case .nXn_Grid:
                return CGSize.zero
            }
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let layOut = dataSource?.getItemType() {
            switch layOut {
            case .top_Banner:
                return 0
            case .row_Item:
                return 10
            case .small_Carousel:
                return 5
            case .nXn_Grid:
                return 0
            }
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let layOut = dataSource?.getItemType() {
            switch layOut {
            case .top_Banner:
                return UIEdgeInsets.zero
            case .row_Item:
                return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            case .small_Carousel:
                return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            case .nXn_Grid:
                return UIEdgeInsets.zero
            }
        }
        return UIEdgeInsets.zero
    }
}

private extension TopBannerCell {
    
    func collectionViewSetup() {
        if let layOut = dataSource?.getItemType() {
            switch layOut {
            case .top_Banner: collectionView.isPagingEnabled = true
            case .row_Item,. small_Carousel,.nXn_Grid: collectionView.isPagingEnabled = false
            }
        }
    }
}
