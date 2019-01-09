//
//  HomeScreenController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/5/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class HomeScreenController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var isHomeContentFetched = false
    private var isBannerSFetched = false
    
    var viewModel: HomeScreenViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Home"
        fetchData()
    }
    
    class func controller() -> HomeScreenController {
        return UIStoryboard(name: "HomeScreen", bundle: nil).instantiateViewController(withIdentifier: "\(HomeScreenController.self)") as! HomeScreenController
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let url = RestApis.tabUrl() else {
            return
        }
        NetworkManager.fetchHomePageDetails(parameters: nil, url: url) { (data) in
            if let data = data.response?.data {
                print(data)
            }
        }
    }

}

extension HomeScreenController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.numberOfSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.collectionView(collectionView , numberOfItemsInSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = viewModel?.collectionView(collectionView, cellForItemAt: indexPath, handler: {[weak self] (info, index) in
            self?.loadVideoPlayer()
        }) {
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension HomeScreenController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel?.collectionView(collectionView, layout:collectionViewLayout, sizeForItemAt:indexPath) ?? CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel?.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewModel?.collectionView(collectionView, layout:collectionViewLayout, insetForSectionAt:section) ?? UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if UICollectionElementKindSectionHeader == kind, let header = viewModel?.collectionView(collectionView,viewForSupplementaryElementOfKind: kind, at: indexPath) as? SectionHeaderView {
            header.viewMoreClicked = { [weak self] (sender, layout) in
                sender.isEnabled = true
                self?.openGridScreen(layOut: layout)
            }
            return header
        }
        return  UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return viewModel?.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section) ?? CGSize.zero
    }
}

private extension HomeScreenController {
    func fetchData() {
        CustomLoader.addLoaderOn(view, gradient: false)
        //Fetch Banners
        NetworkManager.fetchBannerContent(parameters: nil) { [weak self] (data) in
            if let banners = data.response?.data {
                if self?.viewModel == nil {
                    self?.viewModel = HomeScreenViewModel()
                }
                self?.viewModel?.banners = banners
                self?.isBannerSFetched = true
                self?.reloadCollectionView(nil)
            } else {
                self?.reloadCollectionView(APIError.somethingWentWrong)
            }
            
        }
        //Fetch HomeContent
        guard let url = RestApis.tabUrl() else {
            return
        }
        if TabBarItem.selectedTab == .home {
            NetworkManager.fetchHomePageDetails(parameters: nil, url: url) { [weak self] (data) in
                if let layouts = data.response?.data {
                    if self?.viewModel == nil {
                        self?.viewModel = HomeScreenViewModel()
                    }
                    self?.viewModel?.layouts = layouts
                    self?.viewModel?.registerNibWith(collectionView: (self?.collectionView!)!)
                    self?.isHomeContentFetched = true
                    self?.reloadCollectionView(nil)
                } else {
                    self?.reloadCollectionView(APIError.somethingWentWrong)
                }
            }
        } else {
            NetworkManager.fetchContentFor(parameters: nil, url: url) {[weak self] (data) in
                if let layout = data.response?.data {
                    if self?.viewModel == nil {
                        self?.viewModel = HomeScreenViewModel()
                    }
                    self?.viewModel?.layouts = [layout]
                    self?.viewModel?.registerNibWith(collectionView: (self?.collectionView!)!)
                    self?.isHomeContentFetched = true
                    self?.reloadCollectionView(nil)
                } else {
                    self?.reloadCollectionView(APIError.somethingWentWrong)
                }
            }
        }
    }
    
    func openGridScreen(layOut: Layout?) {
        let controller = VideoListController.controller()
        controller.layout = layOut
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func loadVideoPlayer() {
        let controller = VideoDetailController.controller()
        navigationController?.pushViewController(controller, animated: true)
//        guard let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4") else {
//            return
//        }
//        let player = AVPlayer(url: videoURL)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        self.present(playerViewController, animated: true) {
//            playerViewController.player?.play()
//        }
    }
    
    func reloadCollectionView(_ error: Error?) {
        DispatchQueue.main.async {[unowned self] in
            if self.isBannerSFetched && self.isHomeContentFetched {
                self.collectionView.reloadData()
                if let error = error {
                    self.showAlertView("Error!", message: error.localizedDescription)
                }
                CustomLoader.removeLoaderFrom(self.view)
            }
        }
    }
}
