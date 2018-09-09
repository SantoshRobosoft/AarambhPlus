//
//  BannerImageCell.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/8/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class BannerImageCell: UICollectionViewCell {
    
    @IBOutlet weak private var imageView: UIImageView!
    
    func updateUI(dataSource: LayoutProtocol?) {
        imageView.setKfImage(dataSource?.getImageUrl())
    }
}
