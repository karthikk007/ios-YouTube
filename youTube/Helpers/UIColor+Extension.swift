//
//  UIColor+Extension.swift
//  youtube
//
//  Created by Karthik on 30/08/18.
//  Copyright © 2018 Karthik. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
}
