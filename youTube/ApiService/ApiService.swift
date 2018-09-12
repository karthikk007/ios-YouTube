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
    
    let baseUrl: String = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchVideos(completion: @escaping ([Video]) -> ()) {
        fetchFeed(for: "\(baseUrl)/home.json", completion: completion)
    }
    
    func fetchTrendingFeed(completion: @escaping ([Video]) -> ()) {
        fetchFeed(for: "\(baseUrl)/trending.json", completion: completion)
    }
    
    func fetchSubscriptionsFeed(completion: @escaping ([Video]) -> ()) {
        fetchFeed(for: "\(baseUrl)/subscriptions.json", completion: completion)
    }
    
    private func fetchFeed(for url: String, completion: @escaping ([Video]) -> ()) {
        let url = URL(string: url)
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
