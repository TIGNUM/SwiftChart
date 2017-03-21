//
//  EKEvent+CalendarEventUpdating.swift
//  QOT
//
//  Created by Sam Wyndham on 17/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import EventKit

extension EKEvent: CalendarEventData {
    var id: String {
        return eventIdentifier
    }
    
    var modified: Date {
        // Unfortunatly for legacy reasonc lastModifiedDate may be nil. A non nil value is necessary for sane sync so we
        // are setting it to Unix time in such cases.
        return lastModifiedDate ?? Date(timeIntervalSince1970: 0)
    }
    
    var timeZoneID: String? {
        return timeZone?.identifier
    }
    
    var deleted: Bool {
        return false
    }
    
    var coordinate: CLLocationCoordinate2D? {
        return structuredLocation?.geoLocation?.coordinate
    }
    
    var participantsData: [CalendarEventParticipantData] {
        if let attendees = attendees {
            return attendees.map { $0 }
        } else {
            return []
        }
    }
}
