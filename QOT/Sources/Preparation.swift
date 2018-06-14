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

    let calendarEventRemoteID = RealmOptional<Int>(nil)

    @objc dynamic var changeStamp: String?

    @objc dynamic var deleted: Bool = false

    let answers = List<PreparationAnswer>()

    // FIXME: This is a hack. The API must change to allow for storing this ID
    var contentCollectionID: Int {
        return checks.first?.contentItem?.collectionID.value ?? 0
    }

    // MARK: Relationships

    let checks = List<PreparationCheck>()

    @objc private(set) dynamic var event: CalendarEvent?

    lazy var calendarEvent: CalendarEvent? = {
        if self.event != nil { return event }
        guard let eventRemoteID = self.calendarEventRemoteID.value else { return nil }

        do {
            let realm = try RealmProvider().realm()
            return realm.syncableObject(ofType: CalendarEvent.self, remoteID: eventRemoteID)
        } catch {
            // Do nothing
        }
        return nil
    }()

    // MARK: Functions

    convenience init(calendarEvent: CalendarEvent?, name: String, subtitle: String) {
        self.init()
        self.name = name
        self.subtitle = subtitle
        self.changeStamp = UUID().uuidString
        self.calendarEventRemoteID.value = calendarEvent?.remoteID.value
        self.event = calendarEvent
    }

    var notesDictionary: [Int: String] {
        var notes = [Int: String]()
        answers.forEach { (preparationAnswer) in
            notes[preparationAnswer.contentItemID] = preparationAnswer.answer
        }
        return notes
    }

    var checkableItems: List<PreparationCheck> {
        return checks.filter { $0.contentItem?.format != "video" }
    }

    var coveredChecks: List<PreparationCheck> {
        return checkableItems.filter { $0.covered != nil }
    }
}

// MARK: - BuildRelations

extension Preparation: BuildRelations {

    func buildRelations(realm: Realm) {
        // MARK: PreparationCheck
        let predicate = NSPredicate(format: "preparation == %@", self)
        let collections = realm.objects(PreparationCheck.self).filter(predicate)
        collections.forEach { (preparationCheck) in
            preparationCheck.setPreparationRemoteID(self.remoteID.value)
        }
        checks.removeAll()
        checks.append(objectsIn: collections)

        // MARK: Calendar Event
        if event?.remoteID.value != nil && calendarEventRemoteID.value == nil {
            calendarEventRemoteID.value = event?.remoteID.value
        }
    }

    func buildInverseRelations(realm: Realm) {
        guard let remoteID = self.remoteID.value else { return }
        let predicate = NSPredicate(format: "preparationID == %d", remoteID)
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
        if event == nil {
            event = calendarEvent
        }
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
        guard syncStatus != .clean else { return nil }
        let dateFormatter = DateFormatter.iso8601
        let prepareAnswers = Array(answers).map { $0.toJSON() }

        let dict: [JsonKey: JSONEncodable] = [
            .id: remoteID.value.toJSONEncodable,
            .createdAt: dateFormatter.string(from: createdAt),
            .contentId: contentCollectionID,
            .modifiedAt: dateFormatter.string(from: modifiedAt),
            .qotId: localID,
            .name: name,
            .syncStatus: syncStatus.rawValue,
            .subtitle: subtitle,
            .note: notes,
            .eventId: (calendarEventRemoteID.value ?? (event?.remoteID.value ?? nil)).toJSONEncodable,
            .prepareAnswers: JSON.array(prepareAnswers)
        ]

        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}
