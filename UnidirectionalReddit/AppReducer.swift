//
//  AppReducer.swift
//  UnidirectionalReddit
//
//  Created by Demo on 2/17/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

import Foundation
import ReSwift

struct AppReducer: Reducer {
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        var state = state ?? AppState()
        
        switch action as? AppAction {
        case nil:
            break
            
        case .updateSubreddit(let subreddit)?:
            state.subreddit = subreddit
            
        case .loadPost?:
            state.posts = .loading
            
        case .handleLoadPostResult(let result)?:
            switch result {
            case .failure(let error):
                state.posts = .error(error)
                
            case .success(let posts):
                state.posts = .loaded(posts)
            }
            
        }
        
        return state
    }
    
}
