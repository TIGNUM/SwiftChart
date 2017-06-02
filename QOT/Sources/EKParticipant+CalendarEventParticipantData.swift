//
//  EKParticipant+CalendarEventParticipantUpdating.swift
//  QOT
//
//  Created by Sam Wyndham on 17/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import EventKit

extension EKParticipant: CalendarEventParticipantData {
    var type: EKParticipantType {
        return participantType
    }
}
