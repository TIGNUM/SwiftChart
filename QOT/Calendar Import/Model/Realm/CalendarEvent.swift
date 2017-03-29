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
final class CalendarEvent: Object, CalendarEventData {
    private dynamic var _status: Int = -1
    private let _latitude: RealmOptional<Double> = RealmOptional(nil)
    private let _longitude: RealmOptional<Double> = RealmOptional(nil)
    
    private(set) dynamic var id: String = ""
    private(set) dynamic var title: String = ""
    private(set) dynamic var location: String?
    private(set) dynamic var notes: String?
    private(set) dynamic var modified: Date = tempDate
    private(set) dynamic var timeZoneID: String?
    private(set) dynamic var isAllDay: Bool = false
    private(set) dynamic var startDate: Date = tempDate
    private(set) dynamic var endDate: Date = tempDate
    
    dynamic var deleted: Bool = false
    /// The realm participants of the event.
    let participants = List<CalendarEventParticipant>()
    
    var participantsData: [CalendarEventParticipantData] {
        return participants.map { $0 }
    }
    
    var status: EKEventStatus {
        guard let status = EKEventStatus(rawValue: _status) else {
            preconditionFailure("\(_status) is not a valid status")
        }
        return status
    }
    
    var coordinate: CLLocationCoordinate2D? {
        guard let latitude = _latitude.value, let longitude = _longitude.value else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    override class func primaryKey() -> String? {
        return Databsase.Key.primary.rawValue
    }
    
    convenience init(event: CalendarEventData) {
        self.init()
        
        self.id = event.id
        update(with: event)
    }
    
    func update(with event: CalendarEventData) {
        self.title = event.title
        self.location = event.location
        self.notes = event.notes
        self.modified = event.modified
        self.timeZoneID = event.timeZoneID
        self.isAllDay = event.isAllDay
        self.startDate = event.startDate
        self.endDate = event.endDate
        self.deleted = event.deleted
        
        self._status = event.status.rawValue
        self._latitude.value = event.coordinate?.latitude
        self._longitude.value = event.coordinate?.longitude
        
        self.participants.removeAll()
        self.participants.append(objectsIn: event.participantsData.map { CalendarEventParticipant(participant: $0) })
    }
}
