//
//  CalendarEvent.swift
//  QOT
//
//  Created by Sam Wyndham on 14/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import EventKit

private let tempDate = Date()

// FIXME: Unit test once data model is finalized.
final class CalendarEvent: Object {
    private dynamic var _status: Int8 = -1
    private let _latitude: RealmOptional<Double> = RealmOptional(nil)
    private let _longitude: RealmOptional<Double> = RealmOptional(nil)
    
    /// The ID of the event. Currently based on `EKEvent`'s `calendarItemExternalIdentifier`
    private(set) dynamic var id: String = ""
    /// The title of the event.
    private(set) dynamic var title: String = ""
    /// The location of the event or `nil` if not set.
    private(set) dynamic var location: String?
    /// The notes of the event or `nil` if not set.
    private(set) dynamic var notes: String?
    /// The date the event was last modified or `nil` if not modified.
    private(set) dynamic var modified: Date?
    /// The date the event was created or `nil` if not set - unfortunately if may have been synced in a `nil` state.
    private(set) dynamic var created: Date?
    /// The time zone of the event or `nil` if the event is a floating event - one that is not tied to a time zone such 
    /// as *lunch*.
    private(set) dynamic var timeZoneID: String?
    /// Whether the event is an all day event.
    private(set) dynamic var isAllDay: Bool = false
    /// The start date of the event.
    private(set) dynamic var startDate: Date = tempDate
    /// The end date of the event.
    private(set) dynamic var endDate: Date = tempDate
    /// The attendees of the event.
    let attendees = List<CalendarEventParticipant>()
    /// The `CalendarEventStatus` of the event.
    var status: CalendarEventStatus {
        guard let status = CalendarEventStatus(rawValue: _status) else {
            preconditionFailure("\(_status) is not a valid status")
        }
        return status
    }
    /// The coordinate of the event.
    var coordinate: CLLocationCoordinate2D? {
        guard let latitude = _latitude.value, let longitude = _longitude.value else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(event: EKEvent) {
        self.init()
        
        // FIXME: Is using `calendarItemExternalIdentifier` safe. I believe that on sync this value can change.
        self.id = event.calendarItemExternalIdentifier
        self.title = event.title
        self.location = event.location
        self.notes = event.notes
        self.modified = event.lastModifiedDate
        self.created = event.creationDate
        self.timeZoneID = event.timeZone?.identifier
        self.isAllDay = event.isAllDay
        self.startDate = event.startDate
        self.endDate = event.endDate
        
        if let coordinate = event.structuredLocation?.geoLocation?.coordinate {
            self._latitude.value = coordinate.latitude
            self._longitude.value = coordinate.longitude
        } else {
            self._latitude.value = nil
            self._longitude.value = nil
        }
    }
}

/// The calendar item's status.
enum CalendarEventStatus: Int8 {
    // ☠️ WARNING ☠️
    // Do not change the following associated raw values without good reason!!
    
    /// The calendar item has no status.
    case none = 0
    /// The calendar item is confirmed.
    case confirmed = 1
    /// The calendar item is tentative.
    case tentative = 2
    /// The calendar item is canceled.
    case canceled = 3
}
