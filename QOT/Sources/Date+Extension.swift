//
//  Date+Extension.swift
//  QOT
//
//  Created by Moucheg Mouradian on 12/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension Date {

    func isNextDay(date: Date) -> Bool {
        let tomorrow = Calendar.sharedUTC.date(byAdding: .day, value: 1, to: self) ?? Date()

        return Calendar.sharedUTC.isDate(tomorrow, inSameDayAs: date)
    }

    var minutesSinceMidnight: Int {
        let components = Calendar.sharedUTC.dateComponents([.hour, .minute], from: self)

        return 60 * (components.hour ?? 0) + (components.minute ?? 0)
    }

    var dayOfMonth: Int {
        return Calendar.sharedUTC.component(.day, from: self)
    }

    var dayOfWeek: Int {
        return Calendar.sharedUTC.component(.weekday, from: self)
    }

    var weekOfYear: Int {
        return Calendar.sharedUTC.component(.weekOfYear, from: self)
    }

    var monthOfYear: Int {
        return Calendar.sharedUTC.component(.month, from: self)
    }

    func isInCurrentWeek(date: Date) -> Bool {
        return Calendar.sharedUTC.isDate(self, equalTo: date, toGranularity: .weekOfYear)
    }

    func years(to date: Date) -> Int {
        return Calendar.sharedUTC.dateComponents([.year], from: self, to: date).year ?? 0
    }

    func months(to date: Date) -> Int {
        return Calendar.sharedUTC.dateComponents([.month], from: self, to: date).month ?? 0
    }

    func weeks(to date: Date) -> Int {
        return Calendar.sharedUTC.dateComponents([.weekOfMonth], from: self, to: date).weekOfMonth ?? 0
    }

    func days(to date: Date) -> Int {
        return Calendar.sharedUTC.dateComponents([.day], from: self, to: date).day ?? 0
    }

    func hours(to date: Date) -> Int {
        return Calendar.sharedUTC.dateComponents([.hour], from: self, to: date).hour ?? 0
    }

    func minutes(to date: Date) -> Int {
        return Calendar.sharedUTC.dateComponents([.minute], from: self, to: date).minute ?? 0
    }

    var timeIntervalToNow: TimeInterval {
        return -timeIntervalSinceNow
    }
}
