//
//  Result.swift
//  UnidirectionalReddit
//
//  Created by Demo on 2/17/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
