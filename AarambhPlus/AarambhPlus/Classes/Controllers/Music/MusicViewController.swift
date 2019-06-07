//
//  MusicViewController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 02/03/19.
//  Copyright © 2019 Santosh Dev. All rights reserved.
//

import UIKit

enum  MusicHeaderTabType {
    case audio, video
}

final class MusicViewController: BaseViewController {

    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var audioHighlightView: UIView!
    @IBOutlet weak private var videoHighlightView: UIView!
    var searchBarBtn: UIBarButtonItem?
    private var audios: [AudioItem] = []
    private var videos: [AudioItem] = []
    private var selectedTab: MusicHeaderTabType = .audio
    private var audioPageOffset = 0
    private var videoPageOffset = 0
    private var stopFetchingAudioContent = false
    private var stopFetchingVideoContent = false
    private var itemsPerPage = 10
    
    private var mediaItems: [AudioItem] {
        if selectedTab == .audio {
            return audios
        } else {
            return videos
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "RowItemCell", bundle: nil) , forCellWithReuseIdentifier: "RowItemCell")
        videoHighlightView.isHidden = true
        collectionView.delegate = self
        getAudioList()
        //jaganth
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "Aarambha LR Logo.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
        self.searchBarBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "Search_tab"),
                                            style: UIBarButtonItemStyle.plain,
                                            target: self,
                                            action: #selector(searchButtonClicked))
        searchBarBtn?.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = self.searchBarBtn
        
    }
    
    //jaganath
    @objc func searchButtonClicked() {
        
        UIViewController.rootViewController?.navigate(to: SearchViewController.self, of: .home, presentationType: .push, prepareForNavigation: nil)
    }
    
    @IBAction func didSelectAudioButton(_ sender: UIButton) {
        if selectedTab == .audio {
            return
        }
//        audioPageOffset = 0
        collectionView.reloadData()
        audioHighlightView.isHidden = false
        videoHighlightView.isHidden = true
        selectedTab = .audio
//        getAudioList()
    }
    
    @IBAction func didTapVideoButton(_ sender: UIButton) {
        if selectedTab == .video {
            return
        }
//        videoPageOffset = 0
        collectionView.reloadData()
        videoHighlightView.isHidden = false
        audioHighlightView.isHidden = true
        selectedTab = .video
        if videos.isEmpty {
           getVideoList()
        }
    }
    
    class func controller() -> HomeScreenController {
        return UIStoryboard(name: "HomeScreen", bundle: nil).instantiateViewController(withIdentifier: "\(HomeScreenController.self)") as! HomeScreenController
    }
}

extension MusicViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RowItemCell", for: indexPath) as! RowItemCell
        cell.configureCell(dataSource: mediaItems[indexPath.row])
        return cell
    }
}

extension MusicViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 20)/2, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loadVideoDetailController(mediaItems[indexPath.row], isAudio: selectedTab == .audio)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == mediaItems.count - 1 {
            if selectedTab == .audio {
                getAudioList()
            } else {
                getVideoList()
            }
        }
    }
}

extension MusicViewController {
    func getAudioList() {
        if stopFetchingAudioContent {
            return
        }
//        collectionView.isHidden = true
        CustomLoader.addLoaderOn(view, gradient: false)
        var urlStr = "\(RestApis.tabContent)?authToken=\(kAuthToken)&permalink=audio"
        urlStr = "\(urlStr)&limit=\(itemsPerPage)&offset=\(audioPageOffset)"
        audioPageOffset += 1
        NetworkManager.getAudioList(url: urlStr) {[weak self] (response) in
            CustomLoader.removeLoaderFrom(self?.view)
            if let items = self?.parseError(response)?.data {
                if items.isEmpty {
                    self?.stopFetchingAudioContent = true
                } else {
                    self?.audios.append(contentsOf: items)
                }
                self?.collectionView.reloadData()
                self?.collectionView.isHidden = false
            } else {
                //error handling
            }
        }
    }
    
    func getVideoList() {
        if stopFetchingVideoContent {
            return
        }
//        collectionView.isHidden = true
        CustomLoader.addLoaderOn(view, gradient: false)
        var urlStr = "\(RestApis.tabContent)?authToken=\(kAuthToken)&permalink=video-1"
        urlStr = "\(urlStr)&limit=\(itemsPerPage)&offset=\(videoPageOffset)"
        videoPageOffset += 1
        NetworkManager.getVideoList(url: urlStr) { [weak self] (response) in
            CustomLoader.removeLoaderFrom(self?.view)
            if let items = self?.parseError(response)?.data {
                if items.isEmpty {
                    self?.stopFetchingVideoContent = true
                } else {
                    self?.videos.append(contentsOf: items)
                }
                self?.collectionView.reloadData()
                self?.collectionView.isHidden = false
            } else {
                //error handling
            }
        }
    }
    
    func loadVideoDetailController(_ model: Any?, isAudio: Bool) {
        guard let permLink = (model as? MediaItem)?.getPermLink() else {
            showAlertView("Error!", message: "No permlink found.")
            return
        }
        let controller = VideoDetailController.controller(permLink)
        controller.isAudio = isAudio
        navigationController?.pushViewController(controller, animated: true)
    }
}
