//
//  DateComponents+Convenience.swift
//  QOT
//
//  Created by karmic on 14.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension DateComponents {

    static func timeComponents(_ timeIntermediary: GuideTimeIntermediary) -> DateComponents {
        var timeComponents = DateComponents()
        timeComponents.hour = timeIntermediary.hour
        timeComponents.minute = timeIntermediary.minute
        timeComponents.second = timeIntermediary.seconds
        timeComponents.nanosecond = timeIntermediary.nano

        return timeComponents
    }
}
