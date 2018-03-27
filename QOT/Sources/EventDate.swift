//
//  EventDate.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 26/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

extension Date {

    func eventStringDate(endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("h:mm a")

        if NSCalendar.current.isDateInToday(self) {
            return "Today at \(dateFormatter.string(from: self))"
        } else if NSCalendar.current.isDateInTomorrow(self) {
            return "Tomorrow at \(dateFormatter.string(from: self))"
        } else {
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMd")
            return "\(dateFormatter.string(from: self)) // \(dateFormatter.string(from: endDate))"
        }
    }
}
