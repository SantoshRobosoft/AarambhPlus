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
    
    var viewMoreClicked: ((_ sender: UIButton, _ layOut: Layout?)-> Void)?
    private var layout: Layout?
    
    func configureHeader(title: String?, obj: Layout?) {
        self.layout = obj
        self.titleLabel.text = title
    }
    
    @IBAction func didTapViewMoreButton(_ sender: UIButton) {
        sender.isEnabled = false
        viewMoreClicked?(sender, layout)
    }
}
