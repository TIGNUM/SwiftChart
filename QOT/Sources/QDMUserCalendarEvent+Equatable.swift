//
//  QDMUserCalendarEvent+Equatable.swift
//  QOT
//
//  Created by karmic on 08.10.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension QDMUserCalendarEvent: Equatable {
    public static func == (lhs: QDMUserCalendarEvent, rhs: QDMUserCalendarEvent) -> Bool {
        return
            lhs.title == rhs.title &&
            lhs.startDate?.compare(rhs.startDate ?? Date()) == .orderedSame &&
            lhs.endDate?.compare(rhs.endDate ?? Date()) == .orderedSame &&
            lhs.participantCount == rhs.participantCount &&
            lhs.location == rhs.location &&
            lhs.calendarName == rhs.calendarName &&
            lhs.calendarId == rhs.calendarId &&
            lhs.notes == rhs.notes &&
            lhs.timeZoneId == rhs.timeZoneId &&
            lhs.occurrenceDate?.compare(rhs.occurrenceDate ?? Date()) == .orderedSame &&
            lhs.isAllDay == rhs.isAllDay &&
            lhs.url == rhs.url &&
            lhs.status == rhs.status &&
            lhs.isDetached == rhs.isDetached
    }
}
