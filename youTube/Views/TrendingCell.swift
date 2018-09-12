//
//  TrendingCell.swift
//  youtube
//
//  Created by Karthik on 11/09/18.
//  Copyright © 2018 Karthik. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    
    override func fetchVideos() {
        ApiService.sharedInstance.fetchTrendingFeed { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
