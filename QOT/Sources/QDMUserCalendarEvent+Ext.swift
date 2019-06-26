//
//  QDMUserCalendarEvent+Ext.swift
//  QOT
//
//  Created by karmic on 18.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import EventKit
import qot_dal

extension QDMUserCalendarEvent {
    init(event: EKEvent) {
        self.init()
        let now = Date()
        self.createdAt = event.creationDate ?? now
        self.modifiedAt = event.lastModifiedDate ?? now
        self.title = event.title
        self.startDate = event.startDate
        self.endDate = event.endDate
    }

    init(event: CalendarEvent) {
        self.init()
        self.createdAt = event.createdAt
        self.modifiedAt = event.modifiedAt
        self.title = event.title
        self.startDate = event.startDate
        self.endDate = event.endDate
    }
}
