//
//  VideoDetailBaseCell.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 1/11/19.
//  Copyright © 2019 Santosh Dev. All rights reserved.
//

import UIKit

class VideoDetailBaseCell: UITableViewCell {

    var indexPath: IndexPath!
    var addToFavButtonAction: (()-> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(_ info: Movie?, at indexPath: IndexPath) {
        //child class must override this methos
        self.indexPath = indexPath
    }

}

class VDBannerCell: VideoDetailBaseCell {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func configureCell(_ info: Movie?, at indexPath: IndexPath) {
        super.configureCell(info, at: indexPath)
        bannerImageView.setKfImage(info?.poster)
        nameLabel.text = info?.name
    }
    
    @IBAction func didTapAddToFavoriteButton(_ sender: UIButton) {
        addToFavButtonAction?()
    }
    
}

class VDInfoCell: VideoDetailBaseCell {
    
    @IBOutlet weak private var directerNameLabel: UILabel!
    @IBOutlet weak private var durationLabel: UILabel!
    @IBOutlet weak private var languageLabel: UILabel!
    
    override func configureCell(_ info: Movie?, at indexPath: IndexPath) {
        super.configureCell(info, at: indexPath)
        directerNameLabel.text = info?.director
        durationLabel.text = info?.video_duration
        languageLabel.text = info?.content_language
    }
}

class VideoDescription: VideoDetailBaseCell {
    
    @IBOutlet weak private var descLabel: UILabel!
    override func configureCell(_ info: Movie?, at indexPath: IndexPath) {
        super.configureCell(info, at: indexPath)
        descLabel.text = info?.permalink
    }
}
