//
//  RedditAPI.swift
//  UnidirectionalReddit
//
//  Created by Demo on 2/17/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

import Foundation

enum RedditAPIError: Error {
    case invalidSubreddit
    case invalidAPIResponse
}

class RedditAPI {
    
    // MARK: - Properties
    
    let session = URLSession(configuration: .default)
    
    // MARK: - Instance Methods
    
    func getPosts(for subreddit: String, completion: @escaping (Result<[Post]>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.reddit.com"
        components.path = "/r/\(subreddit)"
        
        guard let url = components.url else {
            completion(.failure(RedditAPIError.invalidSubreddit))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            guard let data = data,
                let object = try? JSONSerialization.jsonObject(with: data, options: []),
                let result = object as? [String: Any],
                let resultData = result["data"] as? [String: Any],
                let children = resultData["children"] as? [[String: Any]] else {
                    let error = error ?? RedditAPIError.invalidAPIResponse
                    completion(.failure(error))
                    return
            }
            
            let posts = children.flatMap { dictionary -> Post? in
                guard let data = dictionary["data"] as? [String: Any],
                    let title = data["title"] as? String,
                    let permalink = data["permalink"] as? String else {
                        return nil
                }
                
                return Post(title: title, permalink: permalink)
            }
            
            completion(.success(posts))
            
            }.resume()
    }
    
}
