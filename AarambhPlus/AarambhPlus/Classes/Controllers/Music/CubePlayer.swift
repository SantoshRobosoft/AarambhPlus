//
//  CubePlayerController.swift
//  DarwiniOS
//
//  Created by Santosh Kumar Sahoo on 8/23/18.
//  Copyright © 2018 , DB Corp, Written under contract by Robosoft Technologies Pvt. Ltd. All rights reserved.
//

import UIKit

//let DBCubePlayerTag = 1133

enum CubePlayerType {
    case radio, bulletin
}


protocol CubePlayerProtocol: class {
    func showCube(animate: Bool)
    func removeCube()
}

var cubePlayerImageTag = 122331
var cubePlayerGifTag = 122341

class CubePlayer: NSObject {

    static let shared = CubePlayer()

    private var parentView: UIView?
    private var cubeView: UIView?
    private var dataSource: Any?
    private var type: CubePlayerType = .radio
    
    private override init() {
        super.init()
//        NotificationCenter.default.addObserver(self, selector: #selector(respondToOtherPlayerStateChange), name: .textToSpeechPlayingStateChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(respondToCubePlayerStateChange), name: .audioPlayerStateChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func showCubePlayerOnParent(view: UIView?, withFrame frame: CGRect?, customView: UIView? = nil, type: CubePlayerType, dataSource: Any?) {
        var previousFrame: CGRect?
        if cubeView != nil {
            previousFrame = cubeView?.frame
        }
        removeCubePlayer()
        self.dataSource = dataSource
        self.type = type
        parentView = view
        if let customView = customView {
            cubeView = customView
            cubeView?.backgroundColor = UIColor.lightGray
        } else {
            guard var frame = frame else {
                return
            }
            if let previousFrame = previousFrame {
                frame = previousFrame
            }
            cubeView = UIView(frame: frame)
            cubeView?.backgroundColor = UIColor.lightGray
        }
        guard let cubeView = cubeView else {
            return
        }
        
        let button = UIButton(frame: cubeView.frame)
        button.addTarget(self, action: #selector(cubeViewClicked), for: .touchUpInside)
        button.frame = cubeView.bounds
        cubeView.addSubview(button)
        addShadow()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveViewWithGestureRecognizer(_:)))
        cubeView.addGestureRecognizer(panGesture)
        parentView?.addSubview(cubeView)
    }
    
    func getCubeViewWith(frame: CGRect, gif: String? = nil, imageUrl: String?, isPlaying: Bool) -> UIView {
        var previousFrame: CGRect?
        if let cubeView = cubeView {
            previousFrame = cubeView.frame
            cubePlayer(paused: false)
            if let imageView = cubeView.viewWithTag(cubePlayerImageTag) as? UIImageView {
                imageView.setKfImage(imageUrl)
            }
            return cubeView
        }
        let originalFrame = previousFrame ?? frame
        let customView = UIView(frame: originalFrame)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: originalFrame.width, height: originalFrame.height))
        let gifView = UIImageView(frame: CGRect(x: 0, y: 0, width: originalFrame.width, height: originalFrame.height))
        if isPlaying {
            gifView.loadGif(name: gif ?? "visualizer_gif")
        } else {
            gifView.image = UIImage(named: "pause")
            gifView.contentMode = .center
        }
        gifView.tag = cubePlayerGifTag
        gifView.tintColor = UIColor.white
        imageView.frame = customView.bounds
        gifView.frame = CGRect(x: 10, y: 20, width: customView.bounds.width - 20 , height: customView.bounds.height - 40)
        customView.addSubview(imageView)
        customView.addSubview(gifView)
        imageView.setKfImage(imageUrl)
        imageView.tag = cubePlayerImageTag
        return customView
    }
    
    func removeCubePlayer() {
        cubeView?.removeFromSuperview()
        cubeView = nil
        dataSource = nil
    }
    
    func removeCubePlayerAndStopPlayer() {
        AudioPlayer.shared.stop()
        removeCubePlayer()
    }
    
    @objc func moveViewWithGestureRecognizer(_ sender: UIPanGestureRecognizer) {
        let touchLocation = sender.location(in: parentView)
        cubeView?.center = touchLocation
    }
    
    @objc func cubeViewClicked() {
        switch type {
        case .radio:
            break
        case .bulletin:
            presentBulletinPlayerScreen()
        }
    }
}

private extension CubePlayer {
    
    @objc func respondToOtherPlayerStateChange(_ notification: Notification) {
        guard let isPlaying = notification.object as? Bool, isPlaying else {
            return
        }
        removeCubePlayer()
    }
    
    @objc func respondToCubePlayerStateChange(_ notification: Notification) {
        guard let state = notification.object as? PlayerStatus else {
            return
        }
        switch state {
        case .play:
            cubePlayer(paused: false)
        case .pause:
            cubePlayer(paused: true)
        case .stop:
            removeCubePlayer()
        case .unknown:
            cubePlayer(paused: false)
        case .failed:
            removeCubePlayer()
        }
    }
    
    func presentBulletinPlayerScreen() {
        guard let dataSource = dataSource as? AudioDatasource else {
            return
        }
        if let vc = AudioPlayerViewController.controllerWith(audioItem: dataSource) {
            UIViewController.navController?.topViewController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func addShadow() {
        cubeView?.roundedCorners(radius: 5)
        cubeView?.addShadow()
//        cubeView?.addBorderShadow(color: UIColor.lightGray, opacity: nil, radius: nil, offset: nil)
//        cubeView?.roundedCorners(radius: 5)
//        cubeView?.clipsToBounds = true
    }
    
    func cubePlayer(paused: Bool){
        if let cubeView = cubeView {
            if let gifView = cubeView.viewWithTag(cubePlayerGifTag) as? UIImageView {
                if !paused {
                    gifView.loadGif(name: "visualizer_gif")
                    gifView.contentMode = .scaleAspectFit
                } else {
                    gifView.image = UIImage(named: "pause")
                    gifView.contentMode = .center
                }
            }
        }
    }
    
}
