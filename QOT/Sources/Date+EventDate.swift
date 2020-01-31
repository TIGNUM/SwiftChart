//
//  DateFormatter+EventDate.swift
//  QOT
//
//  Created by Sanggeon Park on 30.01.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension Date {
    var eventDateString: String {
        if self.isToday == true {
            let prefix: String
            let tmp = AppTextService.get(.generic_event_date_format_prefix_today_at)
            if tmp.isEmpty {
                prefix = "Today at"
            } else {
                prefix = tmp
            }
            return String(format: "\(prefix) %@", self.time)
        }
        if self.isYesterday == true {
            let prefix: String
            let tmp = AppTextService.get(.generic_event_date_format_prefix_yesterday_at)
            if tmp.isEmpty {
                prefix = "Yesterday at"
            } else {
                prefix = tmp
            }
            return String(format: "\(prefix) %@", self.time)
        }
        if self.isTomorrow == true {
            let prefix: String
            let tmp = AppTextService.get(.generic_event_date_format_prefix_tomorrow_at)
            if tmp.isEmpty {
                prefix = "Tomorrow at"
            } else {
                prefix = tmp
            }
            return String(format: "\(prefix) %@", self.time)
        }
        if self.isInCurrentWeek == true {
            let atString: String
            let tmp = AppTextService.get(.generic_event_date_format_prefix_at)
            if tmp.isEmpty {
                atString = "at"
            } else {
                atString = tmp
            }
            return String(format: "%@ \(atString) %@", self.weekDayName, self.time)
        }
        return DateFormatter.mediumDate.string(from: self)
    }

}
