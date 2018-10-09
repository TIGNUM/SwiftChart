//
//  EventDate.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 26/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

extension Date {

    var eventStringDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"

        if NSCalendar.current.isDateInToday(self) {
            return "Today at \(dateFormatter.string(from: self))"
        } else if NSCalendar.current.isDateInTomorrow(self) {
            return "Tomorrow at \(dateFormatter.string(from: self))"
        } else {
            dateFormatter.dateFormat = "dd MMMM yyy 'at' h:mm a"
            return dateFormatter.string(from: self)
        }
    }
}
