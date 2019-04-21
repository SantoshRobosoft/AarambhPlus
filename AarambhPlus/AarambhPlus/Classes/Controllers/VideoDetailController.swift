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
    
    private var movie: Movie?
    private var permLink: String?
    var isAudio = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
//        title = "Gazzi"
        getMovieDetail()
    }
    
    class func controller(_ permLink: String) -> VideoDetailController {
        let vc = UIStoryboard(name: "HomeScreen", bundle: nil).instantiateViewController(withIdentifier: "\(VideoDetailController.self)") as! VideoDetailController
        vc.permLink = permLink
        return vc
    }

}

extension VideoDetailController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cellId = getCellId(indexPath), let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? VideoDetailBaseCell {
            cell.configureCell(movie, at: indexPath)
            cell.addToFavButtonAction = { [weak self] in
                self?.addToFabButtonTapped()
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension VideoDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if !UserManager.shared.isLoggedIn {
                self.performSelector(onMainThread: #selector(pushLoginScreen), with: nil, waitUntilDone: false)
            } else {
                loadVideoPlayer()
            }
        }
    }
}

private extension VideoDetailController {
    func loadVideoPlayer() {
        if isAudio {
            if let audioPlayer = AudioPlayerViewController.controllerWith(audioItem: movie) {
                present(audioPlayer, animated: true, completion: nil)
            }
        } else {
            CubePlayer.shared.removeCubePlayerAndStopPlayer()
            guard let url = movie?.movieUrlForTv else {
                showAlertView("Error!", message: "No video url found.")
                return
            }
            guard let videoURL = URL(string: url) else {
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
    
    @objc func pushLoginScreen() {
        navigationController?.pushViewController(LoginController.controller(), animated: true)
    }
    
    func getMovieDetail() {
        guard let permLink = permLink else { return }
        CustomLoader.addLoaderOn(self.view, gradient: false)
        tableView.isHidden = true
        NetworkManager.fetchMovieDetail(paramLink: permLink) {[weak self] (data) in
            CustomLoader.removeLoaderFrom(self?.view)
            if let movie = self?.parseError(data)?.data {
                self?.movie = movie
                self?.tableView.reloadData()
                self?.tableView.isHidden = false
            } else {
                
            }
        }
    }
    
    func getCellId(_ indexPath: IndexPath) -> String? {
        switch indexPath.row {
        case 0:
            return "VDBannerCell"
        case 1:
            return "VDInfoCell"
        case 2:
            return "VideoDescription"
        default:
            return nil
        }
    }
    
    func addToFabButtonTapped() {
        if !UserManager.shared.isLoggedIn {
            UIViewController.rootViewController?.navigate(to: LoginController.self, of: .user, presentationType: .push, prepareForNavigation: nil)
            return
        }
        CustomLoader.addLoaderOn(self.view, gradient: false)
        var param = [String:String]()
        guard  let id = UserManager.shared.user?.id else {
            return
        }
        param["user_id"] = id
        param["movie_uniq_id"] = movie?.muvi_uniq_id
        param["authToken"] = kAuthToken
        NetworkManager.addToFavoriteList(param: param) {[weak self] (status) in
            CustomLoader.removeLoaderFrom(self?.view)
            if let status = self?.parseError(status)?.data {
                if status.status == "Success" {
                    self?.showAlertView("", message: "Successfully added to favorite list")
                } else {
                    self?.showAlertView("Error!", message: status.msg ?? "We are facing some issue, Please try after sometime.")
                }
            }
        }
    }
}
