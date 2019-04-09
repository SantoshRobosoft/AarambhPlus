//
//  HamburgerCell.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class HamburgerProfileCell: UITableViewCell {

    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var profilePicImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func updateUI() {
        if UserManager.shared.isLoggedIn {
            nameLabel.text = UserManager.shared.user?.displayName
            profilePicImageView.setKfImage(UserManager.shared.user?.profilePic)
            //Circle the profile Image
            profilePicImageView?.layer.cornerRadius = (profilePicImageView?.frame.size.width ?? 0.0) / 2
            profilePicImageView?.clipsToBounds = true
            profilePicImageView?.layer.borderWidth = 3.0
            profilePicImageView?.layer.borderColor = UIColor.white.cgColor
        } else {
            nameLabel.text = "Click here to login."
            //Circle the profile Image
            profilePicImageView?.layer.cornerRadius = (profilePicImageView?.frame.size.width ?? 0.0) / 2
            profilePicImageView?.clipsToBounds = true
            profilePicImageView?.layer.borderWidth = 3.0
            profilePicImageView?.layer.borderColor = UIColor.white.cgColor
        }
    }
}

class HamburgerItemCell: UITableViewCell {
    
    @IBOutlet weak private var titleLabel: UILabel!
    
    func updateUI(title: String?) {
        titleLabel.text = title
    }
}
