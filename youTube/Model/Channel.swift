//
//  Channel.swift
//  youtube
//
//  Created by Karthik on 30/08/18.
//  Copyright © 2018 Karthik. All rights reserved.
//

import Foundation

struct Channel: Codable {
    
    var name: String?
    var profileImageName: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImageName = "profile_image_name"
    }
}
