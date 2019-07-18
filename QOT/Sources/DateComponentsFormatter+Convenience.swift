//
//  DateComponentsFormatter+Convenience.swift
//  QOT
//
//  Created by Lee Arromba on 24/10/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension DateComponentsFormatter {

    class func timeIntervalToString(
        _ time: TimeInterval,
        minimumTime: TimeInterval = 0,
        isShort: Bool = false,
        calendar: Calendar = Calendar.sharedUTC,
        unitsStyle: UnitsStyle = .full,
        allowedUnits: NSCalendar.Unit = [.year, .month, .day, .hour, .minute],
        collapsesLargestUnit: Bool = true) -> String? {

        let time = fabs(time) // flip any negative values

        let formatter = DateComponentsFormatter()
        formatter.calendar = calendar
        formatter.unitsStyle = unitsStyle
        formatter.allowedUnits = allowedUnits
        formatter.collapsesLargestUnit = collapsesLargestUnit

        let timeString = formatter.string(from: time < minimumTime ? minimumTime : time)
        if isShort {
            return timeString?.replacingOccurrences(of: ", ", with: ",").split(separator: ",").map({ String($0) }).first
        }
        return timeString
    }

    class func numberOfDays(_ date: Date) -> Int {
        let georgianCalendar = Calendar.init(identifier: .gregorian)
        let components = georgianCalendar.dateComponents([.day], from: date, to: Date())
        guard let days = components.day else { return 0 }
        return days
    }
}
