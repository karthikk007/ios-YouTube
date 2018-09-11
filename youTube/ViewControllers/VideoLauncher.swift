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
            
            player?.play()
            
            player?.addObserver(self, forKeyPath: "currentItem.status", options: .new, context: &playerItemContext)
        }

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
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
