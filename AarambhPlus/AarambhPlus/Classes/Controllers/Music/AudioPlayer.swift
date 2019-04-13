//
//  AudioPlayer.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 27/03/19.
//  Copyright © 2019 Santosh Dev. All rights reserved.
//

import UIKit
import MediaPlayer

enum PlayerStatus :Int {
    case play
    case pause
    case stop
    case unknown
    case failed
}

protocol AudioPlayerDelegate {
    func didPlayerStatusUpdated(status : PlayerStatus)
    func didPlayerSeekValueChanged(currentTime : Int, duration : Int)
    func didUpdateDuration(duration : Int)
}

protocol AudioDatasource: NSObjectProtocol {
    func titleString() -> String?
    func imageUrl() -> String?
    func mediaUrl() -> String?
}

class AudioPlayer : NSObject {
    
    var audioPlayer : AVPlayer?
    private var duration: Int?
    private var currentTime: Int?
    var audioDelegates = [AudioPlayerDelegate]()
    var filePath : URL?
    static let shared = AudioPlayer()
    
    override init() {
        super.init()
    }
    
    func addDelegate(delegate: AudioPlayerDelegate){
        audioDelegates.append(delegate)
    }
    
    func removeDelegate(delegate: AudioPlayerDelegate){
        if audioDelegates.count > 0 {
            audioDelegates.removeLast()
        }
    }
    
    
    func sendPlayerUpdatedStatus(status : PlayerStatus){
        for delegate in audioDelegates {
            delegate.didPlayerStatusUpdated(status: status)
        }
    }
    
    func sendPlayerSeekValueChangedStatus(currentTime : Int, duration : Int){
        for delegate in audioDelegates {
            delegate.didPlayerSeekValueChanged(currentTime: currentTime, duration: duration)
        }
    }
    
    func sendUpdatedDuration(duration : Int){
        for delegate in audioDelegates {
            delegate.didUpdateDuration(duration: duration)
        }
    }
    
    func play() {
        if let url = filePath {
            if audioPlayer == nil {
                do {
                    
                    setupRemoteCommandCenter(enable: true)
                    
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.duckOthers)
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
                    
                    audioPlayer = AVPlayer(url: url)
                    audioPlayer?.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: [.new, .initial], context: nil)
                    audioPlayer?.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status), options:[.new, .initial], context: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.audioPlayerDidFinishPlaying(_:successfully:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: audioPlayer)
                    audioPlayer?.play()
                    sendPlayerUpdatedStatus(status: .play)
                    sendUpdatedDuration(duration: totalDuration())
                    
                } catch {
                    print("Error while starting \(error.localizedDescription)")
                }
            } else {
                audioPlayer?.replaceCurrentItem(with: AVPlayerItem(url: url))
                
            }
            
        }else{
            print("File Path Not Found")
        }
        postNotificationWith(status: .play)
    }
    // MPRemoteCommandCenter
    
    func setupRemoteCommandCenter(enable: Bool) {
        
        let remoteCommandCenter = MPRemoteCommandCenter.shared()
        
        if enable {
            
            remoteCommandCenter.pauseCommand.addTarget(self, action: #selector(remoteCommandCenterPauseCommandHandler))
            remoteCommandCenter.playCommand.addTarget(self, action: #selector(remoteCommandCenterPlayCommandHandler))
            remoteCommandCenter.stopCommand.addTarget(self, action: #selector(remoteCommandCenterPauseCommandHandler))
            remoteCommandCenter.togglePlayPauseCommand.addTarget(self, action: #selector(remoteCommandCenterPlayPauseCommandHandler))
            
        } else {
            
            remoteCommandCenter.pauseCommand.removeTarget(self, action: #selector(remoteCommandCenterPauseCommandHandler))
            remoteCommandCenter.playCommand.removeTarget(self, action: #selector(remoteCommandCenterPlayCommandHandler))
            remoteCommandCenter.stopCommand.removeTarget(self, action: #selector(remoteCommandCenterPauseCommandHandler))
            remoteCommandCenter.togglePlayPauseCommand.removeTarget(self, action: #selector(remoteCommandCenterPlayPauseCommandHandler))
            
        }
        
        remoteCommandCenter.pauseCommand.isEnabled = enable
        remoteCommandCenter.playCommand.isEnabled = enable
        remoteCommandCenter.stopCommand.isEnabled = enable
        remoteCommandCenter.togglePlayPauseCommand.isEnabled = enable
        
    }
    
    func updateNowPlayingInfoCenter(title: String, albumTitle: String) {
        guard let file = self.audioPlayer?.currentItem else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [String: AnyObject]()
            return
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: file.tracks,
            MPMediaItemPropertyAlbumTitle: title,
            MPMediaItemPropertyArtist: albumTitle,
        ]
    }
    
    deinit {
        setupRemoteCommandCenter(enable: false)
    }
    
    
    @objc func remoteCommandCenterPauseCommandHandler() {
        self.pause()
    }
    
    func pause() {
        if let player = audioPlayer {
            player.pause()
            sendPlayerUpdatedStatus(status: .pause)
        }
        postNotificationWith(status: .pause)
    }
    
    func stop() {
        if audioPlayer != nil {
            audioPlayer?.pause()
            audioPlayer = nil
        }
        postNotificationWith(status: .stop)
    }
    
    func seekToBar (value : Float) {
        let seconds : Int64 = Int64(value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        audioPlayer?.seek(to: targetTime)
        if audioPlayer?.rate == 0
        {
            audioPlayer?.play()
            sendPlayerUpdatedStatus(status: .play)
        }
    }
    
    func currentDuration() -> Int {
        if let time =  self.audioPlayer?.currentTime() {
            let total =  CMTimeGetSeconds(time)
            return Int(total)
        }else{
            return 0
        }
    }
    
    @objc func updateCurrentSeekTime(){
        var current:Float64 = 0
        var total:Float64 = 0
        if let time =  self.audioPlayer?.currentTime() {
            current = CMTimeGetSeconds(time)
        }
        if let time =  self.audioPlayer?.currentItem?.asset.duration {
            total =  CMTimeGetSeconds(time)
        }
        let currentTime = Int(current)
        let duration = Int(total)
        sendPlayerSeekValueChangedStatus(currentTime: currentTime, duration: duration)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if let _ = object as? AVPlayer , keyPath == #keyPath(AVPlayer.currentItem.status) {
            let newStatus: AVPlayerItemStatus
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.intValue)!
            } else {
                newStatus = .unknown
            }
            if newStatus == .failed {
                NSLog("Error: \(String(describing: audioPlayer?.currentItem?.error?.localizedDescription)), error: \(String(describing: audioPlayer?.currentItem?.error))")
                audioPlayer = nil
                sendPlayerUpdatedStatus(status: .failed)
            }
        }
    }
    
    func totalDuration() -> Int {
        if let duration =  self.audioPlayer?.currentItem?.asset.duration {
            let total =  CMTimeGetSeconds(duration)
            return Int(total)
        }else{
            return 0
        }
    }
    
    func playerStatus() -> PlayerStatus {
        if audioPlayer?.timeControlStatus == .paused {
            return .pause
        } else if audioPlayer?.timeControlStatus == .playing {
            return .play
        } else {
            return .unknown
        }
    }
    // Player finished playing
    
    @objc func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // ...
        sendPlayerUpdatedStatus(status: .stop)
        removeCubePlayer()
    }
    
    func playPause() {
        if let player = audioPlayer {
            if player.rate == 0 {
                player.play()
                sendPlayerUpdatedStatus(status: .play)
                postNotificationWith(status: .play)
            }else{
                player.pause()
                sendPlayerUpdatedStatus(status: .pause)
                postNotificationWith(status: .pause)
            }
        }else{
            play()
        }
    }
    
    func stopWithOutNotification() {
        stop()
    }
    @objc  func remoteCommandCenterPlayCommandHandler() {
        
        // handle play
        if let player = audioPlayer {
            player.play()
            sendPlayerUpdatedStatus(status: .play)
        }
        postNotificationWith(status: .play)
    }

    @objc func remoteCommandCenterPlayPauseCommandHandler() {
        // handle play pause
        if let player = audioPlayer {
            player.play()
            postNotificationWith(status: .play)
            sendPlayerUpdatedStatus(status: .play)
        }else{
            self.pause()
            sendPlayerUpdatedStatus(status: .pause)
        }
    }
    
    func isCurrentMediaItem(urlString: String?) -> Bool {
        if let urlAsset = (audioPlayer?.currentItem?.asset as? AVURLAsset)?.url, urlAsset.absoluteString == urlString {
            return true
        }
        return false
    }
    
    func setCurrentTime(value: Float) {
        let seconds : Int64 = Int64(value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        audioPlayer?.seek(to: targetTime)
        if playerStatus() == .play {
            audioPlayer?.play()
            sendPlayerUpdatedStatus(status: .play)
        } else if playerStatus() == .pause {
            audioPlayer?.pause()
            sendPlayerUpdatedStatus(status: .pause)
        }
    }
    
    func pausePlayerWithOutNotification() {
        audioPlayer?.pause()
    }
    
    func removeCubePlayer() {
        CubePlayer.shared.removeCubePlayer()
    }
    
    
    @objc func respondToOtherPlayerStateChange(_ notification: Notification) {
        guard let isPlaying = notification.object as? Bool, isPlaying else {
            return
        }
        pause()
    }
    
    func postNotificationWith(status: PlayerStatus) {
//        NotificationCenter.default.post(name: .bulletinPlayerStateChanged, object: status)
    }
}
