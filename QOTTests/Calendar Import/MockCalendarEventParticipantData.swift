//
//  MockCalendarEventParticipantUpdating.swift
//  QOT
//
//  Created by Sam Wyndham on 17/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import EventKit
@testable import QOT

class MockCalendarEventParticipantData: CalendarEventParticipantData {
    var name: String?
    var isCurrentUser: Bool
    var type: EKParticipantType
    
    init(name: String? = "John Doe", isCurrentUser: Bool = false, type: EKParticipantType = .person) {
        self.name = name
        self.isCurrentUser = isCurrentUser
        self.type = type
    }
}
