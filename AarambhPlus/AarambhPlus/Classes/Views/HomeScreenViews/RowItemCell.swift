//
//  RowItemCell.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/8/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class RowItemCell: UICollectionViewCell {
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.addGradientView()
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    func configureCell(dataSource: LayoutProtocol?) {
        imageView.setKfImage(dataSource?.getImageUrl())
        titleLabel.text = dataSource?.getTitle()
    }
    
}
