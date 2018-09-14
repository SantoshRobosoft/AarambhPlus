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
    var layouts = [Layout]()
    
    init(Layout: [Layout]) {
        self.layouts = Layout
        super.init()
//        self.removeLayoutsWithEmptyItems()
    }
    
    func registerNibWith(collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: "TopBannerCell", bundle: nil) , forCellWithReuseIdentifier: "TopBannerCell")
        collectionView.register(UINib(nibName: "RowItemCell", bundle: nil) , forCellWithReuseIdentifier: "RowItemCell")
        collectionView.register(UINib(nibName: "BannerImageCell", bundle: nil) , forCellWithReuseIdentifier: "BannerImageCell")
        collectionView.register(UINib(nibName: "CarouselViewCell", bundle: nil) , forCellWithReuseIdentifier: "CarouselViewCell")
        collectionView.register(UINib(nibName: "SectionHeaderView", bundle: nil ), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeaderView")
    }
    
    func NumberOfSection(in collectionView: UICollectionView) -> Int {
        return layouts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1//layouts[section].mediaItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, handler: cellSelectionHandler?) -> UICollectionViewCell {
        
        if let layOut = layouts[indexPath.section].layOut,let layOuType = LayoutType(rawValue: layOut) {
            switch layOuType {
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
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layOut = layouts[indexPath.section].layOut,let layOuType = LayoutType(rawValue: layOut) {
            switch layOuType {
            case .top_Banner:
                return CGSize(width: windowWidth, height: 220)
            case .row_Item:
                return CGSize(width: windowWidth, height: 200)
            case .small_Carousel:
                return CGSize(width: windowWidth , height: 150)
            case .nXn_Grid:
                return CGSize.zero//CGSize(width: windowWidth, height: 200)
            }
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let layOut = layouts[section].layOut,let layOuType = LayoutType(rawValue: layOut) {
            switch layOuType {
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
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let layOut = layouts[section].layOut,let layOuType = LayoutType(rawValue: layOut) {
            switch layOuType {
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
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let layOut = layouts[indexPath.section].layOut,let layOuType = LayoutType(rawValue: layOut) {
            switch layOuType {
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
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let layOutStr = layouts[section].layOut,let layOuType = LayoutType(rawValue: layOutStr) {
            let layOut = layouts[section].getItem()
            switch layOuType {
            case .row_Item, .small_Carousel:
                if !layOut.isEmpty {
                    return CGSize(width: windowWidth, height: 60)
                }
            case .top_Banner, .nXn_Grid:
                return CGSize.zero
            }
        }
        return CGSize.zero
    }

}

private extension HomeScreenViewModel {
    func removeLayoutsWithEmptyItems() {
        layouts = layouts.filter{$0.mediaItems != nil || $0.mediaItems?.isEmpty == false}
    }
}
