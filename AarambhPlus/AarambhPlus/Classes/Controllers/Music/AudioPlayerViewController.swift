//
//  AudioPlayerViewController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 27/03/19.
//  Copyright © 2019 Santosh Dev. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class AudioPlayerViewController: UIViewController {
    
    @IBOutlet weak private var podcastImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var slider: UISlider!
    @IBOutlet weak private var playButton: UIButton!
    @IBOutlet weak private var startDurationLabel: UILabel!
    @IBOutlet weak private var endDurationLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var blockerView: UIView!
    
    private var isPlaying = false
    private var timer: Timer?
    private var audioItem: AudioDatasource?
    lazy var audioPlayer = AudioPlayer.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        audioPlayer.stop()
////        startAnimatingActivityIndicator()
        setupPlayer()
        startPlaying()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        audioPlayer.removeDelegate(delegate: self)
    }
    
    deinit {
        
    }
    
    class func controllerWith(audioItem: AudioDatasource?) -> AudioPlayerViewController? {
        guard let audioItem = audioItem else {
            return nil
        }
        let controller = UIStoryboard(name: "Music", bundle: nil).instantiateViewController(withIdentifier: "\(AudioPlayerViewController.self)") as? AudioPlayerViewController
        controller?.audioItem = audioItem
        controller?.modalPresentationStyle = .custom
        controller?.transitioningDelegate = controller
        return controller
    }
    
    @IBAction func didTapDismissButton(_ sender: UIButton) {
                showCubePlayer()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapClosePlayerButton(_ sender: UIButton) {
        audioPlayer.stop()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        audioPlayer.setCurrentTime(value: sender.value)
    }
    
    @IBAction func didTapPlayPauseButton(_ sender: UIButton) {
        audioPlayer.playPause()
    }
    
    @IBAction func didTapForwardButton(_ sender: UIButton) {
        if slider.value + 30.0 > Float(audioPlayer.totalDuration()) {
            return
        }
        audioPlayer.setCurrentTime(value: slider.value + 30.0)
    }
    
    @IBAction func didTapRewindButton(_ sender: UIButton) {
        let time = slider.value - 30.0
        audioPlayer.setCurrentTime(value: time > 0 ? time : 0)
    }
}

private extension AudioPlayerViewController {
    
    func showCubePlayer() {
        let customView = CubePlayer.shared.getCubeViewWith(frame: CGRect(x: windowWidth - 150, y: windowHight - 200, width: 150, height: 150), imageUrl: audioItem?.imageUrl(), isPlaying: !(audioPlayer.playerStatus() == .pause))
        CubePlayer.shared.showCubePlayerOnParent(view: UIViewController.tabBarVC?.view, withFrame: nil, customView: customView, type: .bulletin, dataSource: audioItem)
    }
    
    func startAnimatingActivityIndicator() {
        blockerView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopAnimatingActivityIndicator() {
        blockerView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func setupPlayer() {
        podcastImageView.setKfImage(audioItem?.imageUrl())
        titleLabel.text = audioItem?.titleString()
        audioPlayer.addDelegate(delegate: self)
        if audioPlayer.isCurrentMediaItem(urlString: audioItem?.mediaUrl()) {
            
        } else {
            audioPlayer.stopWithOutNotification()
//            audioPlayer.filePath = songFilePathURl
        }
        
        slider.setValue(0, animated: true)
        slider.minimumValue = 0
        startDurationLabel.text = getFormattedTimeAsString(time: Float(audioPlayer.currentDuration()))
        endDurationLabel.text = getFormattedTimeAsString(time: Float(audioPlayer.totalDuration()))
        slider.maximumValue = Float(audioPlayer.totalDuration())
    }
    
    func startPlaying() {
        if audioPlayer.isCurrentMediaItem(urlString: audioItem?.mediaUrl()) {
            if audioPlayer.playerStatus() == .pause {
                if audioPlayer.totalDuration() == audioPlayer.currentDuration() {
                    audioPlayer.setCurrentTime(value: 0)
                }
                audioPlayer.playPause()
            }
            isPlaying = true
            sliderViewSetup()
        } else {
            audioPlayer.filePath = URL(string: audioItem?.mediaUrl()?.relaceString() ?? "")
            audioPlayer.play()
        }
//        showCubePlayer()
        startTimer()
    }
    
    /// Convenience method to get the current time & duration of plyer
    ///
    /// - Returns: current time in string
    func getFormattedTimeAsString(time: Float?) -> String {
        var seconds = 0
        var minutes = 0
        if let time = time {
            seconds = Int(time) % 60
            minutes = (Int(time) / 60) % 60
        }
        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
    
    
    /// This will start timer to update slider bar
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgressBar() {
        if isPlaying {
            slider.setValue(Float(audioPlayer.currentDuration()), animated: true)
            startDurationLabel.text = getFormattedTimeAsString(time: Float(audioPlayer.currentDuration()))
        }
    }
    
    func sliderViewSetup() {
        stopAnimatingActivityIndicator()
        slider.maximumValue = Float(audioPlayer.totalDuration())
        startDurationLabel.text = getFormattedTimeAsString(time: Float(audioPlayer.currentDuration()))
        endDurationLabel.text = "-" + getFormattedTimeAsString(time: Float(audioPlayer.totalDuration()))
        slider.setValue(Float(audioPlayer.currentDuration()), animated: true)
    }
}

extension AudioPlayerViewController : AudioPlayerDelegate {
    func didPlayerStatusUpdated(status: PlayerStatus) {
        if status == .play {
            isPlaying = true
            startTimer()
            playButton.isSelected = false
        }else if status == .pause {
            isPlaying = false
            playButton.isSelected = true
            timer?.invalidate()
            sliderViewSetup()
        } else if status == .stop {
            playButton.isSelected = true
            audioPlayer.pausePlayerWithOutNotification()
            audioPlayer.setCurrentTime(value: 0)
            sliderViewSetup()
        }
        
    }
    
    func didPlayerSeekValueChanged(currentTime: Int, duration: Int) {
        slider.setValue(Float(currentTime), animated: true)
    }
    
    func didUpdateDuration(duration: Int) {
        sliderViewSetup()
    }
}

extension AudioPlayerViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let animator = FadeTransition()
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = FadeTransition()
//        animator.presenting = true
//        animator.duration = 0.2
        return nil
    }
}

