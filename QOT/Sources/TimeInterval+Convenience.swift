//
//  TimeInterval+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 05.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension TimeInterval {

    init(days: Int) {
        self = TimeInterval(days * 60 * 60 * 24)
    }
}
