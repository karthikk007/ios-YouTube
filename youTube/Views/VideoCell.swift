//
//  VideoCell.swift
//  youtube
//
//  Created by Karthik on 30/08/18.
//  Copyright © 2018 Karthik. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}

class VideoCell: BaseCell {
    
    var video: Video? {
        didSet {
            titleLabel.text = video?.title
            setupThumbnailImage()
            setupProfileImage()
            
                
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            
            if let channelName = video?.channel?.name, let numberOfViews = video?.numberOfViews {
                let subtitleText = "\(channelName) ᛫ \(numberFormatter.string(for: numberOfViews)!) ᛫ 2 years ago"
                subtitleTextView.text = subtitleText
            }
            
            // measure title text
            if let title = video?.title {
                let boundingSize = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: CGFloat.greatestFiniteMagnitude)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedSize = title.boundingRect(with: boundingSize, options: options, attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .bold)], context: nil)
                
                if estimatedSize.height > 20 {
                    titleLabelHeightConstraint?.constant = 40
                } else {
                    titleLabelHeightConstraint?.constant = 22
                }
                
            }
        }
    }
    
    func setupThumbnailImage() {
        if let imageURL = video?.thumbnailImageName {
            thumbnailImageView.loadImage(with: imageURL)
        }
    }
    
    func setupProfileImage() {
        if let imageURL = video?.channel?.profileImageName {
            userProfileImageView.loadImage(with: imageURL)
        }
    }
    
    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "taylor_swift_blank_space")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = #imageLiteral(resourceName: "profile_image")
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Taylor Swift - Blank Space"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "TaylorSwiftVEVO ᛫ 1,604,684,607 views ᛫ 2 years ago"
        textView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        textView.textColor = UIColor.lightGray
        textView.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return textView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.85, alpha: 1)
        return view
    }()
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    override func setupViews() {
        
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstraintsWithFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        
        // vertical constraints
        addConstraintsWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-34-[v2(1)]|", views: thumbnailImageView, userProfileImageView, separatorView)
        
        // top constraints
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1.0, constant: 8.0))
        
        // left constraints
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1.0, constant: 8))
        
        // right constraints
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1.0, constant: 0))
        
        // height constraints
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.0, constant: 40)
        addConstraint(titleLabelHeightConstraint!)
        
        
        
        // top constraints
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 4))
        
        // left constraints
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1.0, constant: 8))
        
        // right constraints
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: titleLabel, attribute: .right, multiplier: 1.0, constant: 0))
        
        // height constraints
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.0, constant: 30))
        
    }
}
