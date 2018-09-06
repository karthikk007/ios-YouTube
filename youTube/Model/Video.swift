//
//  Video.swift
//  youtube
//
//  Created by Karthik on 30/08/18.
//  Copyright © 2018 Karthik. All rights reserved.
//

import Foundation

struct Video: Codable {
    
    var thumbnailImageName: String?
    var title: String?
    var channel: Channel?
    var numberOfViews: Int?
    var uploadDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case title
        case thumbnailImageName = "thumbnail_image_name"
        case channel
        case numberOfViews = "number_of_views"
    }
}
