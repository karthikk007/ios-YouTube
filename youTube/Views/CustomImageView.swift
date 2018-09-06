//
//  UIImageView+Extension.swift
//  youtube
//
//  Created by Karthik on 31/08/18.
//  Copyright © 2018 Karthik. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImage(with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            imageUrlString = url.absoluteString
            
            self.image = nil
            
            if let imageFromCache = imageCache.object(forKey: NSString(string: url.absoluteString)) {
                self.image = imageFromCache
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                guard error == nil else {
                    print("error")
                    return
                }
                
                DispatchQueue.main.async {
                    if let imageToCache = UIImage(data: data!) {
                        imageCache.setObject(imageToCache, forKey: NSString(string: url.absoluteString))
                        
                        if self.imageUrlString == urlString {
                            self.image = imageToCache
                        }
                    }
                }
                
            }.resume()
        }
    }
}
