//
//  CalendarEvent.swift
//  QOT
//
//  Created by Sam Wyndham on 17/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import EventKit

protocol CalendarEventData {
    /// The unique ID of the event.
    ///
    /// This is derived from an `EKEvent`'s `eventIdentifier`. An `EKEvent`s identifier may change. For example if the
    /// event changes calendar locally or via another client this identifier will likely change. For now we will treat the
    /// changing of an `eventIdentifier` as the delection of one event and the creation of another event. This may need
    /// to change in the future.
    var id: String { get }
    /// The title of the event.
    var title: String { get }
    /// The location of the event or `nil` if not set.
    var location: String? { get }
    /// The notes of the event or `nil` if not set.
    var notes: String? { get }
    /// The date the event was last modified.
    var modified: Date { get }
    /// The time zone of the event or `nil` if the event is a floating event - one that is not tied to a time zone such
    /// as *lunch*.
    var timeZoneID: String? { get }
    /// Whether the event is an all day event.
    var isAllDay: Bool { get }
    /// The start date of the event.
    var startDate: Date { get }
    /// The end date of the event.
    var endDate: Date { get }
    /// Whether the event is deleted
    var deleted: Bool { get }
    /// The `EKEventStatus` of the event.
    var status: EKEventStatus { get }
    /// The coordinate of the event.
    var coordinate: CLLocationCoordinate2D? { get }
    /// The participants of the event.
    var participantsData: [CalendarEventParticipantData] { get }
}
