//
//  SubscriptionCell.swift
//  youtube
//
//  Created by Karthik on 11/09/18.
//  Copyright © 2018 Karthik. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {
    
    override func fetchVideos() {
        ApiService.sharedInstance.fetchSubscriptionsFeed { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }

}
