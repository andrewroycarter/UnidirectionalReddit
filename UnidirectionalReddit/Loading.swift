//
//  Loading.swift
//  UnidirectionalReddit
//
//  Created by Demo on 2/17/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

import Foundation

enum Loading<T> {
    case notAsked
    case loading
    case loaded(T)
    case error(Error)
}
