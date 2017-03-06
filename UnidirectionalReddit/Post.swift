//
//  Post.swift
//  UnidirectionalReddit
//
//  Created by Demo on 2/17/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

import Foundation

struct Post {
    let title: String
    let permalink: String
    
    var permalinkURL: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.reddit.com"
        components.path = permalink
        return components.url
    }
}
