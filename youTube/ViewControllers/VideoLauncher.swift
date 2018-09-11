//
//  VideoLauncher.swift
//  youtube
//
//  Created by Karthik on 11/09/18.
//  Copyright © 2018 Karthik. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    private var playerItemContext = 0
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv .translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor.red
        slider.maximumTrackTintColor = UIColor.white
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        
        return slider
    }()
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        button.isHidden = true
        
        return button
    }()
    
    var player: AVPlayer?
    var isPlaying = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayerView()
        
        controlsContainerView.frame = self.frame
        
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: controlsContainerView.rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: controlsContainerView.leftAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(controlsContainerView)
        
        backgroundColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPlayerView() {
        if let url = URL(string: "https://www.quirksmode.org/html5/videos/big_buck_bunny.mp4") {
            player = AVPlayer(url: url)
            
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = frame
            
            player?.addObserver(self, forKeyPath: "currentItem.status", options: .new, context: &playerItemContext)
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        }

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "currentItem.loadedTimeRanges" {
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                
                let seconsText = Int(seconds) % 60
                let minutesText = Int(seconds) / 60
                videoLengthLabel.text = "\(String(format: "%02d", minutesText)):\(String(format: "%02d", seconsText))"
            }
        }
        
        if keyPath == "currentItem.status" {
            
            // Only handle observations for the playerItemContext
	            guard context == &playerItemContext else {
                super.observeValue(forKeyPath: keyPath,
                                   of: object,
                                   change: change,
                                   context: context)
                return
            }
            

            
            if keyPath == "currentItem.status" {
                let status: AVPlayerItemStatus
                if let statusNumber = change?[.newKey] as? NSNumber {
                    status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
                } else {
                    status = .unknown
                }
                
                // Switch over status value
                switch status {
                case .readyToPlay:
                    handlePause()
                    activityIndicatorView.stopAnimating()
                    controlsContainerView.backgroundColor = UIColor.clear
                    pausePlayButton.isHidden = false
                case .failed:
                    print("Player error failed")
                case .unknown:
                    print("Player error unknown")
                }
            }
        }
        
        
    }
    
    @objc func handleSliderChange() {
        
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (completed) in
                // do something
            })
        }
        

    }
    
    @objc func handlePause() {
        if isPlaying {
            player?.pause()
            let image = UIImage(named: "play")
            pausePlayButton.setImage(image, for: .normal)
        } else {
            player?.play()
            let image = UIImage(named: "pause")
            pausePlayButton.setImage(image, for: .normal)
        }
        
        isPlaying = !isPlaying
    }
}

class VideoLauncher {
    
    func showVideoPlayer() {
        
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = UIColor.orange
            
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            
            // 16:9 ratio
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerViewFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerViewFrame)
            view.addSubview(videoPlayerView)
            
            keyWindow.addSubview(view)
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                view.frame = keyWindow.frame
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.5, animations: {
                    UIApplication.shared.isStatusBarHidden = true
                })
            })
        }
    }
}
