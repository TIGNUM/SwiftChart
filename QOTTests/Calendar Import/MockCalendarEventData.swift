//
//  MockEvent.swift
//  QOT
//
//  Created by Sam Wyndham on 17/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import EventKit
@testable import QOT

class MockCalendarEventData: CalendarEventData {
    var id: String
    var title: String
    var location: String?
    var notes: String?
    var modified: Date
    var timeZoneID: String?
    var isAllDay: Bool
    var startDate: Date
    var endDate: Date
    var deleted: Bool
    var status: EKEventStatus
    var coordinate: CLLocationCoordinate2D?
    var participantsData: [CalendarEventParticipantData]
    
    init(id: String = UUID().uuidString,
         title: String = "Some Title",
         location: String? = nil,
         notes: String? = nil,
         modified: Date = Date(),
         timeZoneID: String? = nil,
         isAllDay: Bool = false,
         startDate: Date = Date(),
         endDate: Date = Date(timeIntervalSinceNow: 3600),
         deleted: Bool = false,
         status: EKEventStatus = .none,
         coordinate: CLLocationCoordinate2D? = nil,
         participants: [CalendarEventParticipantData] = [])
    {
        self.id = id
        self.title = title
        self.location = location
        self.notes = notes
        self.modified = modified
        self.timeZoneID = timeZoneID
        self.isAllDay = isAllDay
        self.startDate = startDate
        self.endDate = endDate
        self.deleted = deleted 
        self.status = status 
        self.coordinate = coordinate
        self.participantsData = participants
    }
}
