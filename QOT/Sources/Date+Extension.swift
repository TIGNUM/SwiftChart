//
//  Date+Extension.swift
//  QOT
//
//  Created by Moucheg Mouradian on 12/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension Date {

    func years(to date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: self, to: date).year ?? 0
    }

    func months(to date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: self, to: date).month ?? 0
    }

    func weeks(to date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: self, to: date).weekOfMonth ?? 0
    }

    func days(to date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: self, to: date).day ?? 0
    }

    func hours(to date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: self, to: date).hour ?? 0
    }

    func minutes(to date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: self, to: date).minute ?? 0
    }

    func timeToDateAsString(_ date: Date) -> String {
        var time = ""

        var toDate = date

        let years = self.years(to: toDate)
        toDate = Calendar.current.date(byAdding: .year, value: -years, to: toDate)!
        let months = self.months(to: toDate)
        toDate = Calendar.current.date(byAdding: .month, value: -months, to: toDate)!
        let weeks = self.weeks(to: toDate)
        toDate = Calendar.current.date(byAdding: .weekOfMonth, value: -weeks, to: toDate)!
        let days = self.days(to: toDate)
        toDate = Calendar.current.date(byAdding: .day, value: -days, to: toDate)!
        let hours = self.hours(to: toDate)
        toDate = Calendar.current.date(byAdding: .hour, value: -hours, to: toDate)!
        let minutes = self.minutes(to: toDate)

        if years > 0 {
            time = "\(years) " + (years > 1 ? R.string.localized.calendarYears() : R.string.localized.calendarYear())
        }
        if months > 0 {
            time += (time != "" ? " " : "") + "\(months) " + (years > 1 ? R.string.localized.calendarMonths() : R.string.localized.calendarMonth())
        }
        if weeks > 0 {
            time += (time != "" ? " " : "") + "\(weeks) " + (weeks > 1 ? R.string.localized.calendarWeeks() : R.string.localized.calendarWeek())
        }
        if days > 0 {
            time += (time != "" ? " " : "") + "\(days) " + (days > 1 ? R.string.localized.calendarDays() : R.string.localized.calendarDay())
        }
        if hours > 0 {
            time += (time != "" ? " " : "") + "\(hours) " + (hours > 1 ? R.string.localized.calendarHours() : R.string.localized.calendarHour())
        }
        if minutes > 0 {
            time += (time != "" ? " " : "") + "\(minutes) " + (minutes > 1 ? R.string.localized.calendarMinutes() : R.string.localized.calendarMinute())
        }

        return time
    }

    var timeIntervalToNow: TimeInterval {
        return -timeIntervalSinceNow
    }
}
