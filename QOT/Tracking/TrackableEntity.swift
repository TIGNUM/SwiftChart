//
//  TrackableValue.swift
//  QOT
//
//  Created by Sam Wyndham on 13/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

protocol TrackableEntity {
    var trackableEntityID: Int { get }
}

extension ContentCategory: TrackableEntity {
    var trackableEntityID: Int {
        return id
    }
}

extension Content: TrackableEntity {
    var trackableEntityID: Int {
        return id
    }
}
