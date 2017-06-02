//
//  CalendarEventParticipantUpdating.swift
//  QOT
//
//  Created by Sam Wyndham on 17/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import EventKit

/// An interface for a `CalendarEvent`'x participant.
protocol CalendarEventParticipantData: class {
    /// The name of `self`.
    var name: String? { get }
    /// Whether `self` is the current user.
    var isCurrentUser: Bool { get }
    /// The type `self`.
    var type: EKParticipantType { get }
}
