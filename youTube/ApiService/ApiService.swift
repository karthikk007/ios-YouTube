//
//  ApiService.swift
//  youtube
//
//  Created by Karthik on 10/09/18.
//  Copyright © 2018 Karthik. All rights reserved.
//

import Foundation

class ApiService {
    static let sharedInstance = ApiService()
    
    func fetchVideos(completion: @escaping ([Video]) -> ()) {
        let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            var videos = [Video]()
            
            guard error == nil else {
                print("error")
                return
            }
            
            guard let content = data else {
                print("no data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode([Video].self, from: content)
                
                videos = json
                
                print(json)
                
                DispatchQueue.main.async {
                    completion(videos)
                }
                
            } catch let error {
                print(error)
            }
            
            }.resume()
    }
}
