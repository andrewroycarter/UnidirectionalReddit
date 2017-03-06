//
//  AppState.swift
//  UnidirectionalReddit
//
//  Created by Demo on 2/17/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType {
    var subreddit: String? = nil
    var posts: Loading<[Post]> = .notAsked
}
