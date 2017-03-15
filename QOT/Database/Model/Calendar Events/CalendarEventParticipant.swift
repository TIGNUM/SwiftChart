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
final class CalendarEventParticipant: Object {
    private dynamic var _type: Int8 = -1
    
    /// The name of `self`.
    private(set) dynamic var name: String?
    /// Whether `self` is the current user.
    private(set) dynamic var isCurrentUser: Bool = false
    /// The type `self`.
    var type: CalendarEventParticipantType {
        guard let type = CalendarEventParticipantType(rawValue: _type) else {
            preconditionFailure("\(_type) is not a valid participent type")
        }
        return type
    }
    
    convenience init(participant: EKParticipant) {
        self.init()
        
        self._type = CalendarEventParticipantType(type: participant.participantType).rawValue
        self.name = participant.name
        self.isCurrentUser = participant.isCurrentUser
    }
}

/// The type of `CalendarEventParticipant`.
enum CalendarEventParticipantType: Int8 {
    // ☠️ WARNING ☠️
    // Do not change the following associated raw values without good reason!!
    
    /// The participant’s type is unknown.
    case unknown = 0
    /// The participant is a person.
    case person = 1
    /// The participant is a room.
    case room = 2
    /// The participant is a resource.
    case resource = 3
    /// The participant is a group.
    case group = 4
    
    init(type: EKParticipantType) {
        switch type {
        case .unknown:
            self = .unknown
        case .person:
            self = .person
        case .room:
            self = .room
        case .resource:
            self = .resource
        case .group:
            self = .group
        }
    }
}
