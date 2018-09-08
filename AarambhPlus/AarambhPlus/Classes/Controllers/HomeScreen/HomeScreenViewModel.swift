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


class HomeScreenViewModel: NSObject {
    var layouts = [Layout]()
    
    init(Layout: [Layout]) {
        self.layouts = Layout
        super.init()
        self.removeLayoutsWithEmptyItems()
    }
    
    func registerNibWith(collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: "TopBannerCell", bundle: nil) , forCellWithReuseIdentifier: "TopBannerCell")
        collectionView.register(UINib(nibName: "RowItemCell", bundle: nil) , forCellWithReuseIdentifier: "RowItemCell")
        collectionView.register(UINib(nibName: "BannerImageCell", bundle: nil) , forCellWithReuseIdentifier: "BannerImageCell")
    }
    
    func NumberOfSection(in collectionView: UICollectionView) -> Int {
        return layouts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1//layouts[section].mediaItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopBannerCell", for: indexPath) as! TopBannerCell
            cell.configureCell(info: layouts[indexPath.section])
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layOut = layouts[indexPath.section].layOut,let layOuType = LayoutType(rawValue: layOut) {
            switch layOuType {
            case .top_Banner:
                return CGSize(width: windowWidth, height: 180)
            case .row_Item:
                return CGSize(width: windowWidth, height: 120)
            case .small_Carousel:
                return CGSize(width: windowWidth , height: 100)
            case .nXn_Grid:
                return CGSize.zero
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

}

private extension HomeScreenViewModel {
    func removeLayoutsWithEmptyItems() {
        layouts = layouts.filter{$0.mediaItems != nil || $0.mediaItems?.isEmpty == false}
    }
}
