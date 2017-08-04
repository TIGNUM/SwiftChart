//
//  Preparation.swift
//  QOT
//
//  Created by Sam Wyndham on 26.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy
import EventKit

final class Preparation: SyncableObject {

    // MARK: Public Properties

    fileprivate(set) dynamic var contentID: Int = 0

    fileprivate(set) dynamic var title: String = ""
    
    fileprivate(set) dynamic var subtitle: String = ""
    
    fileprivate(set) dynamic var calendarEventRemoteId: Int = 0

    dynamic var calendarEvent: CalendarEvent?
    
    dynamic var changeStamp: String? = UUID().uuidString
    
    dynamic var deleted: Bool = false
    
    // MARK: Functions

    convenience init(contentID: Int, calendarEvent: CalendarEvent?, title: String, subtitle: String) {
        self.init()
        self.contentID = contentID
        self.calendarEvent = calendarEvent
        self.title = title
        self.subtitle = subtitle
    }
}

// MARK: - TwoWaySyncable

extension Preparation: TwoWaySyncable {
    
    func setData(_ data: PreparationIntermediary, objectStore: ObjectStore) throws {
        contentID = data.contentID
        title = data.title
        subtitle = data.subtitle
        calendarEventRemoteId = data.calendarEventRemoteId
    }
    
    static var endpoint: Endpoint {
        return .userPreparation
    }

    func toJson() -> JSON? {
        guard syncStatus != .clean else {
            return nil
        }
        if let calendarEvent = calendarEvent, calendarEvent.syncStatus == .createdLocally {
            return nil
        }

        let dateFormatter = DateFormatter.iso8601
        var dict: [JsonKey: JSONEncodable] = [
            .qotId: localID,
            .createdAt: dateFormatter.string(from: createdAt),
            .modifiedAt: dateFormatter.string(from: modifiedAt),
            .syncStatus: syncStatus.rawValue,
            .title: title,
            .subtitle: subtitle,
            .contentId: contentID,
            .id: remoteID.value.toJSONEncodable
        ]
        if let calendarEvent = calendarEvent {
            dict[.eventId] = calendarEvent.remoteID.value.toJSONEncodable
        }
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}
