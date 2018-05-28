//
//  PreparationService.swift
//  QOT
//
//  Created by Sam Wyndham on 27.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import RealmSwift
import EventKit

final class PreparationService {

    private let mainRealm: Realm
    private let realmProvider: RealmProvider

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func preparations() -> AnyRealmCollection<Preparation> {
        return mainRealm.anyCollection()
    }

    func preparation(localID: String) -> Preparation? {
        return mainRealm.syncableObject(ofType: Preparation.self, localID: localID)
    }

    func preparationChecks(preparationID: String) -> AnyRealmCollection<PreparationCheck> {
        return mainRealm.preparationChecks(preparationID: preparationID)
    }

    func preparationsOnBackground(predicate: NSPredicate? = nil) throws -> AnyRealmCollection<Preparation> {
        if let predicate = predicate {
            return try realmProvider.realm().anyCollection(predicates: predicate)
        } else {
            return try realmProvider.realm().anyCollection()
        }
    }

    func preparationChecksOnBackground() throws -> AnyRealmCollection<PreparationCheck> {
        return try realmProvider.realm().anyCollection()
    }

    func preparationChecksOnBackground(preparationID: String) throws -> AnyRealmCollection<PreparationCheck> {
        return try realmProvider.realm().preparationChecks(preparationID: preparationID)
    }

    func createPreparation(contentCollectionID: Int,
                           event: EKEvent?,
                           name: String,
                           subtitle: String) throws -> String {
        let realm = try self.realmProvider.realm()
        guard let contentCollection = realm.syncableObject(ofType: ContentCollection.self, remoteID: contentCollectionID) else {
            throw SimpleError(localizedDescription: "No content collection for contentCollectionID: \(contentCollectionID)")
        }

        var calendarEvent: CalendarEvent?
        if let event = event, event.startDate != nil, event.endDate != nil {
            calendarEvent = realm.calendarEventForEKEvent(event)
        }

        let preparation = Preparation(calendarEvent: calendarEvent, name: name, subtitle: subtitle)
        let relatedContents = mainRealm.syncableObjects(ofType: ContentCollection.self,
                                                        remoteIDs: contentCollection.relatedDefaultContentIDs)
        let relatedContentItems = relatedContents.compactMap { $0.prepareItems }.compactMap { $0.first }
        relatedContentItems.forEach { (item: ContentItem) in
            preparation.checks.append(PreparationCheck(preparation: preparation, contentItem: item, covered: nil))
        }
        let videoItem = contentCollection.items.filter { $0.format == "video" }.first
        let check = PreparationCheck(preparation: preparation, contentItem: videoItem, covered: nil)
        preparation.checks.insert(check, at: 0)

        try realm.write {
            realm.add(preparation)
        }
        return preparation.localID
    }

    func saveNotes(_ notes: String, preparationID: String) throws {
        guard let preparation = preparation(localID: preparationID) else { return }
        let realm = try self.realmProvider.realm()
        try realm.write {
            preparation.notes = notes
        }
    }

    func deletePreparation(withLocalID localID: String) throws {
        let realm = try self.realmProvider.realm()
        guard let preparation = realm.syncableObject(ofType: Preparation.self, localID: localID) else {
            throw SimpleError(localizedDescription: "No preparation with local id: \(localID)")
        }
        try removeLinkFromEventNotes(forPreparation: preparation)
        try deletePreparationChecks(preparation.checks)
        try realm.write {
            if preparation.remoteID.value == nil {
                realm.delete(preparation)
            } else {
                preparation.deleted = true
                preparation.didUpdate()
            }
        }
    }

    func deletePreparationChecks(_ checks: List<PreparationCheck>) throws {
        let realm = try self.realmProvider.realm()
        try realm.write {
            checks.forEach { (check: PreparationCheck) in
                if check.remoteID.value == nil {
                    realm.delete(check)
                } else {
                    check.deleted = true
                    check.didUpdate()
                }
            }
        }
    }

    func updatePreparationChecks(preparationID: String,
                                 checkedIDs: [Int: Date?],
                                 selectedStrategies: [WeeklyChoice]) throws {
        guard let preparation = preparation(localID: preparationID) else { return }
        try deletePreparationChecks(preparation.checks)
        if selectedStrategies.isEmpty == false {
            var checks = [PreparationCheck]()
            let contentIDs = selectedStrategies.compactMap { $0.contentCollectionID }
            let relatedContents = mainRealm.syncableObjects(ofType: ContentCollection.self,
                                                            remoteIDs: contentIDs)
            let relatedContentItems = relatedContents.compactMap { $0.prepareItems }.compactMap { $0.first }
            relatedContentItems.forEach { (item: ContentItem) in
                var covered: Date?
                if let coveredDate = checkedIDs[item.remoteID.value ?? 0] {
                    covered = coveredDate
                }
                checks.append(PreparationCheck(preparation: preparation,
                                               contentItem: item,
                                               covered: covered))
            }

            if let content = mainRealm.syncableObject(ofType: ContentCollection.self,
                                                      remoteID: preparation.contentCollectionID) {
                let videoItem = content.items.filter { $0.format == "video" }.first
                checks.insert(PreparationCheck(preparation: preparation, contentItem: videoItem, covered: nil), at: 0)
            }

            let realm = try self.realmProvider.realm()
            try realm.write {
                preparation.checks.append(objectsIn: checks)
            }
        }
    }

    func eraseData() {
        do {
            try mainRealm.write {
                mainRealm.delete(preparations())
            }
        } catch {
            assertionFailure("Failed to delete preparations with error: \(error)")
        }
    }

    func removeLinkFromEventNotes(forPreparation preparation: Preparation) throws {
        guard let event = preparation.calendarEvent?.event, let notes = event.notes else {
            return
        }
        let regex = try NSRegularExpression(pattern: "(qotapp:\\/\\/preparation#[A-Z0-9-]+)", options: [])
        guard let regexMatch = regex.matches(in: notes, options: [], range: NSRange(location: 0, length: notes.count)).first else {
            return
        }
        // FIXME: swift 4 has ability to convert NSRange -> Range, so we can then use string.removeSubrange()
        // @see https://stackoverflow.com/questions/25138339/nsrange-to-rangestring-index
        event.notes = (notes as NSString).replacingCharacters(in: regexMatch.range, with: "")
    }

    // `checks` is a map of `ContentItem.remoteID` to check date.
    func updatePreparation(localID: String,
                           checks: [Int: Date?],
                           notes: String,
                           notesDictionary: [Int: String]) throws {
        let realm = try self.realmProvider.realm()
        guard let preparation = realm.syncableObject(ofType: Preparation.self, localID: localID) else { return }
        let checkObjects = preparationChecks(preparationID: localID)
        try realm.write {
            preparation.notes = notes
            preparation.answers.removeAll()
            let answers = createPreparationAnswers(notesDictionary, preparationID: preparation.localID, realm: realm)
            preparation.answers.append(objectsIn: answers)
            preparation.didUpdate()

            checkObjects.forEach({ (checkObject: PreparationCheck) in
                guard let covered: Date? = checks[checkObject.contentItemID],
                    // guards state did change
                    ((covered == nil && checkObject.covered != nil) ||
                        (covered != nil && checkObject.covered == nil)) else {
                            return
                }
                checkObject.covered = covered
                checkObject.didUpdate()
            })
        }
    }

    private func createPreparationAnswers(_ notesDictionary: [Int: String],
                                          preparationID: String,
                                          realm: Realm) -> [PreparationAnswer] {
        var answers = [PreparationAnswer]()
        notesDictionary.forEach { (contentItemID: Int, answer: String) in
            if let prepAnswer = preparationAnswer(preparationID, contentItemID) {
                prepAnswer.answer = answer
                answers.append(prepAnswer)
            } else {
                answers.append(PreparationAnswer(answer: answer,
                                                 contentItemID: contentItemID,
                                                 preparationID: preparationID))
            }
        }
        return answers
    }

    private func preparationAnswer(_ preparationID: String, _ contentItemID: Int) -> PreparationAnswer? {
        let predicate = NSPredicate(format: "preparationID == %@ AND contentItemID == %d", preparationID, contentItemID)
        return mainRealm.objects(PreparationAnswer.self).filter(predicate).first
    }
}

// MARK: - private

private extension Realm {

    func preparationChecks(preparationID: String) -> AnyRealmCollection<PreparationCheck> {
        return anyCollection(predicates: .deleted(false), .preparationID(preparationID))
    }

    func calendarEventForEKEvent(_ ekEvent: EKEvent) -> CalendarEvent {
        guard let startDate = ekEvent.startDate,
            let endDate = ekEvent.endDate,
            let existing = objects(CalendarEvent.self).filter(title: ekEvent.title,
                                                              startDate: startDate,
                                                              endDate: endDate).first else {
            return CalendarEvent(event: ekEvent)
        }
        return existing
    }
}
