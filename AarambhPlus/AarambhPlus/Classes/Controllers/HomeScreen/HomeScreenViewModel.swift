//
//  HomeScreenViewModel.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/8/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

enum LayoutType: String {
    case top_Banner = "Top_Banner", row_Item = "Row_Item", small_Carousel = "Small_Carousel", nXn_Grid = "nXn_Grid"
    
}

typealias cellSelectionHandler = ((_ model: Any?, _ index: Int) -> Void)

class HomeScreenViewModel: NSObject {
    private var _layOuts = [Layout]()
    var layouts: [Layout] {
        set {
            _layOuts = newValue
            if let bannerLayout = bannerLayout {
                _layOuts.insert(bannerLayout, at: 0)
            }
        }
        get {
            return _layOuts
        }
    }
    var bannerLayout: Layout?
    var banners = [Banner]() {
        didSet {
            bannerLayout = Layout()
            bannerLayout?._mediaItems = banners
            bannerLayout?.layoutType = .top_Banner
        }
    }
    
    func registerNibWith(collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: "TopBannerCell", bundle: nil) , forCellWithReuseIdentifier: "TopBannerCell")
        collectionView.register(UINib(nibName: "RowItemCell", bundle: nil) , forCellWithReuseIdentifier: "RowItemCell")
        collectionView.register(UINib(nibName: "BannerImageCell", bundle: nil) , forCellWithReuseIdentifier: "BannerImageCell")
        collectionView.register(UINib(nibName: "CarouselViewCell", bundle: nil) , forCellWithReuseIdentifier: "CarouselViewCell")
        collectionView.register(UINib(nibName: "SectionHeaderView", bundle: nil ), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeaderView")
    }
    
    func numberOfSection() -> Int {
        return layouts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1//layouts[section].mediaItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, handler: cellSelectionHandler?) -> UICollectionViewCell {
        
        let layOut = layouts[indexPath.section].layoutType
        switch layOut {
        case .top_Banner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselViewCell", for: indexPath) as! CarouselViewCell
            cell.handler = handler
            cell.configureCellWith(layout: layouts[indexPath.section])
            return cell
        case .row_Item, .nXn_Grid, .small_Carousel:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopBannerCell", for: indexPath) as! TopBannerCell
            cell.handler = handler
            cell.configureCell(info: layouts[indexPath.section])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layOut = layouts[indexPath.section].layoutType
        switch layOut {
        case .top_Banner:
            return CGSize(width: collectionView.frame.width, height: 220)
        case .row_Item:
            return CGSize(width: collectionView.frame.width - 20, height: 200)
        case .small_Carousel:
            return CGSize(width: collectionView.frame.width - 10, height: 150)
        case .nXn_Grid:
            return CGSize.zero//CGSize(width: windowWidth, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let layOut = layouts[section].layoutType
        switch layOut {
        case .top_Banner:
            return 0
        case .row_Item:
            return 0
        case .small_Carousel:
            return 0
        case .nXn_Grid:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let layOut = layouts[section].layoutType
        switch layOut {
        case .top_Banner:
            return UIEdgeInsets.zero
        case .row_Item:
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        case .small_Carousel:
            return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        case .nXn_Grid:
            return UIEdgeInsets.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let layOut = layouts[indexPath.section].layoutType
        switch layOut {
        case .row_Item:
            if UICollectionElementKindSectionHeader == kind {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeaderView", for: indexPath)as! SectionHeaderView
                header.configureHeader(title: layouts[indexPath.section].getTitle(), obj: layouts[indexPath.section])
                return header
            }
        case .small_Carousel:
            if UICollectionElementKindSectionHeader == kind {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeaderView", for: indexPath)as! SectionHeaderView
                header.configureHeader(title: layouts[indexPath.section].getTitle(), obj: layouts[indexPath.section])
                return header
            }
        case .nXn_Grid:
            return UICollectionReusableView()
            //                if UICollectionElementKindSectionHeader == kind {
            //                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeaderView", for: indexPath) as! SectionHeaderView
            //                    header.configureHeader(title: layouts[indexPath.section].getTitle())
            //                    return header
        //                }
        case .top_Banner:
            return UICollectionReusableView()
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let layOuType = layouts[section].layoutType
        let layOut = layouts[section].getItem()
        switch layOuType {
        case .row_Item, .small_Carousel:
            if !layOut.isEmpty {
                return CGSize(width: windowWidth, height: 60)
            }
        case .top_Banner, .nXn_Grid:
            return CGSize.zero
        }
        return CGSize.zero
    }

}

private extension HomeScreenViewModel {
    func removeLayoutsWithEmptyItems() {
        layouts = layouts.filter{$0.mediaItems != nil || $0.mediaItems?.isEmpty == false}
    }
}
