//
//  AppAction.swift
//  UnidirectionalReddit
//
//  Created by Demo on 2/17/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

import Foundation
import ReSwift

func getPosts(with api: RedditAPI) -> (String) -> Store<AppState>.ActionCreator {
    return { subreddit in
        return { state, store in
            if case .loading = state.posts,
                case .loaded = state.posts {
                return nil
            }
            
            api.getPosts(for: subreddit) { result in
                DispatchQueue.main.async {
                    store.dispatch(AppAction.handleLoadPostResult(result))
                }
            }
            
            return AppAction.loadPost
        }
    }
}

enum AppAction: Action {
    case updateSubreddit(String?)
    case loadPost
    case handleLoadPostResult(Result<[Post]>)
}
