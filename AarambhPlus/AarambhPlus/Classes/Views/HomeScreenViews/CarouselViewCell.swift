//
//  CarouselViewCell.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/14/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class CarouselViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var carouselView: iCarousel!
    @IBOutlet weak private var pageControl: UIPageControl!
    
    private var layout: Layout?
    private var items: [MediaItem] {
        return layout?.mediaItems ?? []
    }
    var timer: Timer?
    var handler: cellSelectionHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        carouselView.delegate = self
        carouselView.dataSource = self
        carouselView.isPagingEnabled = true
        timer?.invalidate()
    }
    
    func configureCellWith(layout: Layout) {
        self.layout = layout
        carouselView.reloadData()
        carouselView.isScrollEnabled = items.count == 1 ? false : true
        pageControl.numberOfPages = items.count
        pageControl.currentPage = 0
        pageControl.isHidden = items.count == 1 ? true : false
        if items.count > 1 {
            timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(autoScrollBanner), userInfo: nil, repeats: true)
        }
    }
    
    @objc func autoScrollBanner() {
        let index = carouselView.currentItemIndex == (items.count - 1) ? 0 : carouselView.currentItemIndex + 1
        carouselView.scrollToItem(at: index, animated: true)
    }
}
extension CarouselViewCell: iCarouselDataSource, iCarouselDelegate {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return items.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
//        var label: UILabel
        var itemView: UIImageView
        //reuse view if available, otherwise create a new view
        if let view = view as? UIImageView {
            itemView = view
            //get a reference to the label in the recycled view
//            label = itemView.viewWithTag(1) as! UILabel
        } else {
            //don't do anything specific to the index within
            //this `if ... else` statement because the view will be
            //recycled and used with other index values later
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: windowWidth, height: 220))
            itemView.setKfImage(items[index].image)
            itemView.clipsToBounds = true
            itemView.layer.borderColor = UIColor.white.cgColor
            itemView.layer.borderWidth = 4
            itemView.contentMode = .scaleAspectFill
        }
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .wrap : return 1.0
        default : return value
        }
    }

    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        handler?(items[index], index)
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        pageControl.currentPage = carousel.currentItemIndex
    }
}
