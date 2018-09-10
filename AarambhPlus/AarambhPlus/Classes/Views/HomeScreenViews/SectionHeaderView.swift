//
//  SectionHeaderView.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/10/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    
    func configureHeader(title: String?) {
        self.titleLabel.text = title
    }
    
    @IBAction func didTapViewMoreButton(_ sender: UIButton) {
        
    }
}
