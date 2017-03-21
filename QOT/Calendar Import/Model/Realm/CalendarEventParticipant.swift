//
//  CalendarEventParticipant.swift
//  QOT
//
//  Created by Sam Wyndham on 14/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import EventKit

// FIXME: Unit test once data model is finalized.

/// A parcipant in a `CalendarEvent`.
final class CalendarEventParticipant: Object, CalendarEventParticipantData {
    private dynamic var _type: Int = -1
    
    private(set) dynamic var name: String?
    private(set) dynamic var isCurrentUser: Bool = false
    
    var type: EKParticipantType {
        guard let type = EKParticipantType(rawValue: _type) else {
            preconditionFailure("\(_type) is not a valid participent type")
        }
        return type
    }
    
    convenience init(participant: CalendarEventParticipantData) {
        self.init()
        
        self._type = participant.type.rawValue
        self.name = participant.name
        self.isCurrentUser = participant.isCurrentUser
    }
}
