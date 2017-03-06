//
//  ViewModel.swift
//  UnidirectionalReddit
//
//  Created by Demo on 2/17/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

import Foundation

struct ViewModel {
    
    let statusMessage: String?
    let statusLabelHidden: Bool
    let activityIndicatorHidden: Bool
    let statusViewHidden: Bool
    let posts: [Post]
    let searchBarText: String?
    
    init(_ state: AppState) {
        searchBarText = state.subreddit
        
        switch state.posts {
        case .error(let error):
            statusMessage = error.localizedDescription
            statusLabelHidden = false
            statusViewHidden = false
            activityIndicatorHidden = true
            posts = []
            
        case .loading:
            statusMessage = nil
            statusLabelHidden = true
            statusViewHidden = false
            activityIndicatorHidden = false
            posts = []
            
        case .loaded(let posts):
            statusMessage = nil
            statusLabelHidden = true
            statusViewHidden = true
            activityIndicatorHidden = true
            self.posts = posts
            
        case .notAsked:
            statusMessage = nil
            statusLabelHidden = true
            statusViewHidden = true
            activityIndicatorHidden = true
            posts = []
        }
    }
    
}
