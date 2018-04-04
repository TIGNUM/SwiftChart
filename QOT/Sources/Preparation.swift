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

    @objc private(set) dynamic var name: String = ""

    @objc private(set) dynamic var subtitle: String = ""

    @objc dynamic var notes: String = ""

    @objc dynamic var intentionNotesPerceiving: String = ""

    @objc dynamic var intentionNotesKnowing: String = ""

    @objc dynamic var intentionNotesFeeling: String = ""

    @objc dynamic var reflectionNotes: String = ""

    @objc dynamic var reflectionNotesVision: String = ""

    let calendarEventRemoteID = RealmOptional<Int>(nil)

    @objc dynamic var changeStamp: String? = UUID().uuidString

    @objc dynamic var deleted: Bool = false

    let answers = List<PreparationAnswer>()

    // FIXME: This is a hack. The API must change to allow for storing this ID
    var contentCollectionID: Int {
        return checks.first?.contentItem?.collectionID.value ?? 0
    }

    // MARK: Relationships

    @objc private(set) dynamic var calendarEvent: CalendarEvent?

    let checks = List<PreparationCheck>()

    // MARK: Functions

    convenience init(calendarEvent: CalendarEvent?, contentCollectionID: Int, name: String, subtitle: String) {
        self.init()
        self.calendarEvent = calendarEvent
        self.name = name
        self.subtitle = subtitle
    }

    var notesDictionary: [Int: String] {
        var notes = [Int: String]()
        answers.forEach { (preparationAnswer) in
            notes[preparationAnswer.contentItemID] = preparationAnswer.answer
        }

        return notes
    }
}

// MARK: - BuildRelations

extension Preparation: BuildRelations {

    func buildInverseRelations(realm: Realm) {
        let predicate = NSPredicate(format: "preparation == %@", self)
        let collections = realm.objects(PreparationCheck.self).filter(predicate)
        checks.removeAll()
        checks.append(objectsIn: collections)
    }
}

// MARK: - TwoWaySyncable

extension Preparation: TwoWaySyncable {

    func setData(_ data: PreparationIntermediary, objectStore: ObjectStore) throws {
        name = data.name
        subtitle = data.subtitle
        notes = data.notes
        calendarEventRemoteID.value = data.calendarEventRemoteID

        objectStore.delete(answers)
        let newAnswers = data.answers.map { PreparationAnswer(answer: $0.answer,
                                                              contentItemID: $0.contentItemID,
                                                              preparationID: localID) }
        answers.append(objectsIn: newAnswers)
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
        let prepareAnswers = Array(answers).map { $0.toJSON() }
        var dict: [JsonKey: JSONEncodable] = [
            .id: remoteID.value.toJSONEncodable,
            .createdAt: dateFormatter.string(from: createdAt),
            .contentId: contentCollectionID,
            .modifiedAt: dateFormatter.string(from: modifiedAt),
            .qotId: localID,
            .name: name,
            .syncStatus: syncStatus.rawValue,
            .subtitle: subtitle,
            .note: notes,
            .eventId: (calendarEvent?.remoteID.value ?? nil).toJSONEncodable,
            .prepareAnswers: JSON.array(prepareAnswers)
        ]
        if let calendarEvent = calendarEvent {
            dict[.eventId] = calendarEvent.remoteID.value.toJSONEncodable
        }
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}
