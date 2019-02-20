//
//  Date+Extension.swift
//  QOT
//
//  Created by Moucheg Mouradian on 12/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension Date {

    init(milliseconds: Double) {
        self.init(timeIntervalSince1970: milliseconds/1000.0)
    }

    init(milliseconds: Int) {
        self.init(milliseconds: Double(milliseconds))
    }

    /// dateFormatter.dateStyle = .long
    /// dateFormatter.timeStyle = .short
    /// March 30. 2018 at 12:00 AM
    var longDateShortTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }

    var twentyOneYearsAgo: Date {
        return Calendar.sharedUTC.date(byAdding: .year, value: -21, to: self) ?? self
    }

    var minimumDateOfBirth: Date {
        return Calendar.sharedUTC.date(byAdding: .year, value: -130, to: self) ?? self
    }

    var maximumDateOfBirth: Date {
        return Calendar.sharedUTC.date(byAdding: .year, value: -16, to: self) ?? self
    }

    var startOfDay: Date {
        return Calendar.sharedUTC.startOfDay(for: self)
    }

    var endOfDay: Date {
        return Calendar.sharedUTC.date(byAdding: .minute, value: -1, to: self.nextDay.startOfDay) ?? self
    }

    var nextHour: Date {
        return Calendar.current.nextDate(after: self, matching: DateComponents(minute: 0), matchingPolicy: .nextTime) ?? self
    }

    var nextDate: Date {
        return Calendar.current.nextDate(after: self, matching: DateComponents(hour: 0), matchingPolicy: .nextTime) ?? self
    }

    var nextDay: Date {
        return Calendar.sharedUTC.date(byAdding: .day, value: 1, to: self) ?? self
    }

    func isNextDay(date: Date) -> Bool {
        return date.isSameDay(nextDay)
    }

    func dayBefore(days: Int) -> Date {
        return Calendar.sharedUTC.date(byAdding: .day, value: (-days), to: self) ?? self
    }

    func dayAfter(days: Int) -> Date {
        return Calendar.sharedUTC.date(byAdding: .day, value: days, to: self) ?? self
    }

    func isSameDay(_ date: Date?) -> Bool {
        if let date = date {
            let componentsFirst = Calendar.sharedUTC.dateComponents([.year, .month, .day], from: date)
            let componentsSecond = Calendar.sharedUTC.dateComponents([.year, .month, .day], from: self)
            let sameYear = componentsFirst.year == componentsSecond.year
            let sameMonth = componentsFirst.month == componentsSecond.month
            let sameDay = componentsFirst.day == componentsSecond.day
            return sameYear && sameMonth && sameDay
        }
        return false
    }

    var minutesSinceMidnight: Int {
        let components = Calendar.current.dateComponents([.hour, .minute], from: self)

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

    var monthDescription: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let monthDescription = dateFormatter.string(from: self)
        return monthDescription
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

    var isNight: Bool {
        return minutesSinceMidnight <= 5*60 || minutesSinceMidnight >= 21*60
    }

    var isPast: Bool {
        return self < Date()
    }

    var isToday: Bool {
        return self.isSameDay(Date())
    }
}
