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
    
    private var audios: [MediaItem]?
    private var selectedTab: MusicHeaderTabType = .audio
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "RowItemCell", bundle: nil) , forCellWithReuseIdentifier: "RowItemCell")
        videoHighlightView.isHidden = true
        getAudioList()
    }
    
    @IBAction func didSelectAudioButton(_ sender: UIButton) {
        audioHighlightView.isHidden = false
        videoHighlightView.isHidden = true
        selectedTab = .audio
    }
    
    @IBAction func didTapVideoButton(_ sender: UIButton) {
        videoHighlightView.isHidden = false
        audioHighlightView.isHidden = true
        selectedTab = .video
    }
    
    class func controller() -> HomeScreenController {
        return UIStoryboard(name: "HomeScreen", bundle: nil).instantiateViewController(withIdentifier: "\(HomeScreenController.self)") as! HomeScreenController
    }
}

extension MusicViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return audios?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RowItemCell", for: indexPath) as! RowItemCell
        cell.configureCell(dataSource: audios?[indexPath.row])
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedTab == .audio {
            let vc = AudioPlayerViewController.controllerWith(audioItem: audios?[indexPath.row])
            present(vc!, animated: true, completion: nil)
        }
    }
}

extension MusicViewController {
    func getAudioList() {
        CustomLoader.addLoaderOn(view, gradient: false)
        NetworkManager.getAudioList {[weak self] (response) in
            CustomLoader.removeLoaderFrom(self?.view)
            if let items = self?.parseError(response)?.data {
                self?.audios = items
                self?.collectionView.reloadData()
            } else {
                //error handling
            }
        }
    }
}
