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

    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        return Calendar.current.date(byAdding: .minute, value: -1, to: self.nextDay.startOfDay) ?? self
    }

    var nextDate: Date {
        return Calendar.current.nextDate(after: self, matching: DateComponents(hour: .zero), matchingPolicy: .nextTime) ?? self
    }

    var nextDay: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self) ?? self
    }

    func isNextDay(date: Date) -> Bool {
        return date.isSameDay(nextDay)
    }

    func dayAfter(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }

    func dayAfter(months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self) ?? self
    }

    func firstDayOfMonth() -> Date {
        guard let interval = Calendar.current.dateInterval(of: .month, for: self) else { return self }
        return interval.start
    }

    func firstDayOfWeek() -> Date {
        guard let interval = Calendar.current.dateInterval(of: .weekOfYear, for: self) else { return self }
        return interval.start
    }

    func lastDayOfMonth() -> Date {
        guard let interval = Calendar.current.dateInterval(of: .month, for: self) else { return self }
        return interval.end
    }

    func lastDayOfWeek() -> Date {
        guard let interval = Calendar.current.dateInterval(of: .weekOfYear, for: self) else { return self }
        return interval.end
    }

    func isSameDay(_ date: Date?) -> Bool {
        if let date = date {
            let componentsFirst = Calendar.current.dateComponents([.year, .month, .day], from: date)
            let componentsSecond = Calendar.current.dateComponents([.year, .month, .day], from: self)
            let sameYear = componentsFirst.year == componentsSecond.year
            let sameMonth = componentsFirst.month == componentsSecond.month
            let sameDay = componentsFirst.day == componentsSecond.day
            return sameYear && sameMonth && sameDay
        }
        return false
    }

    func isBetween(date: Date, andDate: Date) -> Bool {
        return (date <= self && self <= andDate) || (andDate <= self && self <= date)
    }

    var minutesSinceMidnight: Int {
        let components = Calendar.current.dateComponents([.hour, .minute], from: self)
        return 60 * (components.hour ?? .zero) + (components.minute ?? .zero)
    }

    var dayOfMonth: Int {
        return Calendar.current.component(.day, from: self)
    }

    var dayOfWeek: Int {
        return Calendar.current.component(.weekday, from: self)
    }

    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }

    var monthDescription: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let monthDescription = dateFormatter.string(from: self)
        return monthDescription
    }

    var weekDayName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }

    var isInCurrentWeek: Bool {
        let daysFromNow = Date().days(to: self)
        return dayOfWeek - daysFromNow >= .zero
    }

    func year() -> Int {
        return Calendar.sharedUTC.dateComponents([.year], from: self).year ?? .zero
    }

    func month() -> Int {
        return Calendar.sharedUTC.dateComponents([.month], from: self).month ?? 0
    }

    func day() -> Int {
        return Calendar.sharedUTC.dateComponents([.day], from: self).day ?? 0
    }

    func hour() -> Int {
        return Calendar.sharedUTC.dateComponents([.hour], from: self).hour ?? 0
    }

    func years(to date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: self, to: date).year ?? .zero
    }

    func months(to date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: self, to: date).month ?? .zero
    }

    func weeks(to date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: self, to: date).weekOfMonth ?? .zero
    }

    func days(to date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: self, to: date).day ?? .zero
    }

    func hours(to date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: self, to: date).hour ?? .zero
    }

    func minutes(to date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: self, to: date).minute ?? .zero
    }

    var isNight: Bool {
        return minutesSinceMidnight <= 5*60 || minutesSinceMidnight >= 21*60
    }

    var isPast: Bool {
        return self < Date()
    }

    var isYesterday: Bool {
        return self.isSameDay(Date().dayAfter(days: -1))
    }

    var isToday: Bool {
        return self.isSameDay(Date())
    }

    var isTomorrow: Bool {
        return Date().isNextDay(date: self)
    }

    var is24hoursOld: Bool {
        return Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? .zero > 24
    }

    var time: String {
        return DateFormatter.displayTime.string(from: self)
    }

    static func weekdayNameFrom(weekdayNumber: Int, short: Bool) -> String {
        let calendar = Calendar.current
        let dayIndex = ((weekdayNumber - 1) + (calendar.firstWeekday - 1)) % 7
        return short ? calendar.shortWeekdaySymbols[dayIndex] : calendar.weekdaySymbols[dayIndex]
    }

    func weekdayNumberOrdinal() -> Int {
        let calendar = Calendar.current
        var dayOfWeek = calendar.component(.weekday, from: Date()) + 1 - calendar.firstWeekday
        if dayOfWeek <= .zero {
            dayOfWeek += 7
        }
        return dayOfWeek
    }
}
