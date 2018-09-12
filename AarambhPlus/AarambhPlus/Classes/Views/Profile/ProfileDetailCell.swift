//
//  ProfileDetailCell.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/12/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class ProfileDetailCell: UITableViewCell {

    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    private var user = UserManager.shared.user
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell() {
        profilePicImageView.setKfImage(user?.profilePic)
        nameLabel.text = user?.displayName
        emailLabel.text = user?.email
    }
}
