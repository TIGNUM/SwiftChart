//
//  EKEvent+JSONEncodable.swift
//  QOT
//
//  Created by Sam Wyndham on 20.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy
import EventKit

extension EKEvent {

    public func toJSON(id: Int?, createdAt: Date, modifiedAt: Date, syncStatus: Int, localID: String) -> JSON {
        let dict: [JsonKey: JSONEncodable] = [
            .id: id.toJSONEncodable,
            .createdAt: createdAt,
            .modifiedAt: modifiedAt,
            .syncStatus: syncStatus,
            .qotId: localID,
            .calendarItemExternalId: (calendarItemExternalIdentifier ?? nil).toJSONEncodable,
            .calendarId: calendar.calendarIdentifier,
            .title: (title ?? nil).toJSONEncodable,
            .location: location.toJSONEncodable,
            .notes: notes.toJSONEncodable,
            .timeZoneId: (timeZone?.identifier).toJSONEncodable,
            .isAllDay: isAllDay,
            .startDate: (startDate ?? nil).toJSONEncodable,
            .endDate: (endDate ?? nil).toJSONEncodable,
            .url: (url?.absoluteString).toJSONEncodable,
            .availability: availability,
            .occurrenceDate: (occurrenceDate ?? nil).toJSONEncodable,
            .isDetached: isDetached,
            .status: status,
            .organizer: organizer.toJSONEncodable,
            .attendees: (attendees.map { $0.toJSON() }) ?? JSON.null,
            .coordinates: structuredLocation.toJSONEncodable,
            .recurrenceRules: (recurrenceRules.map { $0.toJSON() }) ?? JSON.null
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}

extension Optional where Wrapped: JSONEncodable {
    var toJSONEncodable: JSONEncodable {
        switch self {
        case .none:
            return JSON.null
        case .some(let wrapped):
            return wrapped
        }
    }
}

extension JSON: JSONEncodable {
    public func toJSON() -> JSON {
        return self
    }
}

extension Date: JSONEncodable {
    public func toJSON() -> JSON {
        return DateFormatter.iso8601.string(from: self).toJSON()
    }
}

extension EKParticipant: JSONEncodable {

    public func toJSON() -> JSON {
        /*
         WARNING ☠️ - There appears to be and EventKit bug that can cause a crash when accessing a participant URL. So
         we are using safeURL here: See https://stackoverflow.com/q/40804131
         */
        let urlString = safeURL()?.absoluteString
        let dict: [JsonKey: JSONEncodable] = [
            .isCurrentUser: isCurrentUser,
            .name: name.toJSONEncodable,
            .role: participantRole,
            .status: participantStatus,
            .type: participantType,
            .url: urlString.toJSONEncodable
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}

extension EKStructuredLocation: JSONEncodable {

    public func toJSON() -> JSON {
        let dict: [JsonKey: JSONEncodable] = [
            .longitude: (geoLocation?.coordinate.longitude).toJSONEncodable,
            .latitude: (geoLocation?.coordinate.latitude).toJSONEncodable,
            .radius: radius
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}

extension EKRecurrenceRule: JSONEncodable {

    public func toJSON() -> JSON {
        let dict: [JsonKey: JSONEncodable] = [
            .recurranceEnd: recurrenceEnd.toJSONEncodable,
            .frequency: frequency,
            .interval: interval,
            .firstDayOfTheWeek: firstDayOfTheWeek,
            .daysOfTheWeek: (daysOfTheWeek.map { $0.toJSON() }) ?? JSON.null,
            .daysOfTheMonth: (daysOfTheMonth.map { $0.map({ $0.intValue }).toJSON() }) ?? JSON.null,
            .daysOfTheYear: (daysOfTheYear.map { $0.map({ $0.intValue }).toJSON() }) ?? JSON.null,
            .weeksOfTheYear: (weeksOfTheYear.map { $0.map({ $0.intValue }).toJSON() }) ?? JSON.null,
            .monthsOfTheYear: (monthsOfTheYear.map { $0.map({ $0.intValue }).toJSON() }) ?? JSON.null,
            .setPositions: (setPositions.map { $0.map({ $0.intValue }).toJSON() }) ?? JSON.null
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}

extension EKRecurrenceEnd: JSONEncodable {

    public func toJSON() -> JSON {
        let dict: [JsonKey: JSONEncodable] = [
            .endDate: endDate.toJSONEncodable,
            .occurrenceCount: occurrenceCount
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}

extension EKRecurrenceDayOfWeek: JSONEncodable {

    public func toJSON() -> JSON {
        let dict: [JsonKey: JSONEncodable] = [
            .dayOfTheWeek: dayOfTheWeek.rawValue,
            .weekNumber: weekNumber
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}

extension EKEventAvailability: JSONEncodable {

    public func toJSON() -> JSON {
        return stringValue.toJSON()
    }

    private var stringValue: String {
        switch self {
        case .notSupported:
            return "UNSUPPORTED"
        case .busy:
            return "BUSY"
        case .free:
            return "FREE"
        case .tentative:
            return "TENTATIVE"
        case .unavailable:
            return "UNAVAILABLE"
        }
    }
}

extension EKEventStatus: JSONEncodable {

    public func toJSON() -> JSON {
        return stringValue.toJSON()
    }

    private var stringValue: String {
        switch self {
        case .none:
            return "NONE"
        case .confirmed:
            return "CONFIRMED"
        case .tentative:
            return "TENTATIVE"
        case .canceled:
            return "CANCELED"
        }
    }
}

extension EKParticipantStatus: JSONEncodable {

    public func toJSON() -> JSON {
        return stringValue.toJSON()
    }

    private var stringValue: String {
        switch self {
        case .unknown:
            return "UNKNOWN"
        case .pending:
            return "PENDING"
        case .accepted:
            return "ACCEPTED"
        case .declined:
            return "DECLINED"
        case .tentative:
            return "TENTATIVE"
        case .delegated:
            return "DELEGATED"
        case .completed:
            return "COMPLETED"
        case .inProcess:
            return "INPROCESS"
        }
    }
}

extension EKParticipantRole: JSONEncodable {

    public func toJSON() -> JSON {
        return stringValue.toJSON()
    }

    var stringValue: String {
        switch self {
        case .unknown:
            return "UNKNOWN"
        case .required:
            return "REQUIRED"
        case .optional:
            return "OPTIONAL"
        case .chair:
            return "CHAIR"
        case .nonParticipant:
            return "NON_PARTICIPANT"
        }
    }
}

extension EKParticipantType: JSONEncodable {

    public func toJSON() -> JSON {
        return stringValue.toJSON()
    }

    var stringValue: String {
        switch self {
        case .unknown:
            return "UNKNOWN"
        case .person:
            return "PERSON"
        case .room:
            return "ROOM"
        case .resource:
            return "RESOURCE"
        case .group:
            return "GROUP"
        }
    }
}

extension EKRecurrenceFrequency: JSONEncodable {

    public func toJSON() -> JSON {
        return stringValue.toJSON()
    }

    var stringValue: String {
        switch self {
        case .daily:
            return "DAILY"
        case .weekly:
            return "WEEKLY"
        case .monthly:
            return "MONTHLY"
        case .yearly:
            return "YEARLY"
        }
    }
}
