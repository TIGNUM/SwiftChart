//
//  Defines.swift
//  QOT
//
//  Created by karmic on 23/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

// MARK: - Debug

#if DEBUG
    private let isDebug						= true
#else
    private let isDebug 					= false
#endif

struct Verbose {

    struct Database {
        static let Content					= false
    }

    struct Manager {
        static let API						= false
        static let Database					= false
        static let Helper					= false
    }
}
