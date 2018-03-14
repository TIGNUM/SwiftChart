//
//  EKCalendar+Convenience.swift
//  QOT
//
//  Created by karmic on 13.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

extension EKCalendar {

    var toggleIdentifier: String {
        return String(format: "%@%@%@", title, Toggle.seperator, (source != nil ? source.title : ""))
    }
}
