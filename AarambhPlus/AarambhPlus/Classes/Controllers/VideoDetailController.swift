//
//  VideoDetailController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/21/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoDetailController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        title = "Gazzi"
    }
    
    class func controller() -> VideoDetailController {
        return UIStoryboard(name: "HomeScreen", bundle: nil).instantiateViewController(withIdentifier: "\(VideoDetailController.self)") as! VideoDetailController
    }

}

extension VideoDetailController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "MovieImageCell", for: indexPath)
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: "MoviesInfo", for: indexPath)
        case 2:
            return tableView.dequeueReusableCell(withIdentifier: "VideoDescription", for: indexPath)
        default:
            return UITableViewCell()
        }
    }
}

extension VideoDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            loadVideoPlayer()
        }
    }
}

private extension VideoDetailController {
    func loadVideoPlayer() {
        guard let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4") else {
            return
        }
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
}
