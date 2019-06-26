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
        return AnyRealmCollection(mainRealm.objects(Preparation.self))
    }

    func preparation(localID: String) -> Preparation? {
        return mainRealm.syncableObject(ofType: Preparation.self, localID: localID)
    }

    func preparationChecks(preparationID: String) -> AnyRealmCollection<PreparationCheck> {
        return mainRealm.preparationChecks(preparationID: preparationID)
    }

    func preparationsOnBackground(predicate: NSPredicate? = nil) throws -> AnyRealmCollection<Preparation> {
        if let predicate = predicate {
            return try AnyRealmCollection(realmProvider.realm().objects(Preparation.self).filter(predicate))
        } else {
            return try AnyRealmCollection(realmProvider.realm().objects(Preparation.self))
        }
    }

    func preparationChecksOnBackground() throws -> AnyRealmCollection<PreparationCheck> {
        return try AnyRealmCollection(realmProvider.realm().objects(PreparationCheck.self))
    }

    func preparationChecksOnBackground(preparationID: String) throws -> AnyRealmCollection<PreparationCheck> {
        return try realmProvider.realm().preparationChecks(preparationID: preparationID)
    }

    func createPreparation(contentCollectionID: Int,
                           event: CalendarEvent?,
                           name: String,
                           subtitle: String) throws -> String? {
        let realm = try self.realmProvider.realm()
        guard let contentCollection = realm.syncableObject(ofType: ContentCollection.self, remoteID: contentCollectionID) else {
            throw SimpleError(localizedDescription: "No content collection for contentCollectionID: \(contentCollectionID)")
        }

        let preparation = Preparation(calendarEvent: event, name: name, subtitle: subtitle)
        let relatedContents = mainRealm.syncableObjects(ofType: ContentCollection.self,
                                                        remoteIDs: contentCollection.relatedDefaultContentIDs)
        let relatedContentItems = relatedContents.compactMap { $0.prepareItems }.compactMap { $0.first }
        relatedContentItems.forEach { (item: ContentItem) in
            preparation.checks.append(PreparationCheck(preparation: preparation, contentItem: item, covered: nil))
        }
        let videoItem = contentCollection.items.filter { $0.format == "video" }.first
        let check = PreparationCheck(preparation: preparation, contentItem: videoItem, covered: nil)
        preparation.checks.insert(check, at: 0)

        try realm.transactionSafeWrite {
            realm.add(preparation)
        }
        return preparation.localID
    }

    func saveNotes(_ notes: String, preparationID: String) {
        DispatchQueue.global().async {
            do {
                let realm = try self.realmProvider.realm()
                guard let preparation = realm.syncableObject(ofType: Preparation.self, localID: preparationID) else {
                    return
                }
                try realm.transactionSafeWrite {
                    preparation.notes = notes
                }
            } catch {
                log("saveNotes - failed: \(error.localizedDescription)", level: .error)
            }
        }
    }

    func deletePreparation(withLocalID localID: String) throws {
        let realm = try self.realmProvider.realm()
        guard let preparation = realm.syncableObject(ofType: Preparation.self, localID: localID) else {
            throw SimpleError(localizedDescription: "No preparation with local id: \(localID)")
        }
        try removeLinkFromEventNotes(forPreparation: preparation)
        try deletePreparationChecks(preparation.checks, realm: realm)
        try realm.transactionSafeWrite {
            if preparation.remoteID.value == nil {
                realm.delete(preparation)
            } else {
                preparation.deleted = true
                preparation.didUpdate()
            }
        }
        NotificationCenter.default.post(Notification(name: .startSyncPreparationRelatedData))
    }

    func deletePreparationChecks(_ checks: List<PreparationCheck>, realm: Realm) throws {
        try realm.transactionSafeWrite {
            var checkArrayToDelete = [PreparationCheck]()
            checks.dropFirst().forEach { (check: PreparationCheck) in
                if check.remoteID.value == nil {
                    checkArrayToDelete.append(check)
                } else {
                    check.deleted = true
                    check.didUpdate()
                }
            }
            realm.delete(checkArrayToDelete)
        }
    }

    func eraseData() {
        do {
            try mainRealm.transactionSafeWrite {
                mainRealm.delete(preparations())
            }
        } catch {
            assertionFailure("Failed to delete preparations with error: \(error)")
        }
    }

    func removeLinkFromEventNotes(forPreparation preparation: Preparation) throws {
        guard let event = preparation.calendarEvent()?.event, let notes = event.notes else {
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
        try realm.transactionSafeWrite {
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
            NotificationCenter.default.post(Notification(name: .startSyncPreparationRelatedData))
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
        return AnyRealmCollection(objects(PreparationCheck.self).filter(.deleted(false)).filter(.preparationID(preparationID)))
    }

    func calendarEventForEKEvent(_ ekEvent: EKEvent) -> CalendarEvent {
        guard let existing = objects(CalendarEvent.self).filter(ekEvent: ekEvent).first else {
            return CalendarEvent(event: ekEvent)
        }
        return existing
    }
}
