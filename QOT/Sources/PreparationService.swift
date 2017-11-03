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

    func createPreparation(contentCollectionID: Int, event: EKEvent?, name: String, subtitle: String) throws -> String {
        let realm = try self.realmProvider.realm()
        guard let contentCollection = realm.syncableObject(ofType: ContentCollection.self, remoteID: contentCollectionID) else {
            throw SimpleError(localizedDescription: "No content collection for contentCollectionID: \(contentCollectionID)")
        }
        
        var calendarEvent: CalendarEvent?
        if let event = event {
            calendarEvent = realm.calendarEventForEKEvent(event)
        }
        
        let preparation = Preparation(calendarEvent: calendarEvent, contentCollectionID: contentCollectionID, name: name, subtitle: subtitle)
        contentCollection.items.forEach { (item: ContentItem) in
            preparation.checks.append(PreparationCheck(preparation: preparation, contentItem: item, covered: nil))
        }
        try realm.write {
            realm.add(preparation)
        }
        return preparation.localID
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

    /// Updates `PreparationCheck`s for a `Preparation.localID`. `checks` is a map of `ContentItem.remoteID` to check date.
    func updateChecks(preparationID: String, checks: [Int: Date?]) throws {
        let realm = try self.realmProvider.realm()
        let checkObjects = preparationChecks(preparationID: preparationID)
        try realm.write {
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
}

// MARK: - private

private extension Realm {

    func preparationChecks(preparationID: String) -> AnyRealmCollection<PreparationCheck> {
        return anyCollection(predicates: .deleted(false), .preparationID(preparationID))
    }
    
    func calendarEventForEKEvent(_ ekEvent: EKEvent) -> CalendarEvent {
        let predicate = NSPredicate.calendarEvent(title: ekEvent.title,
                                                  startDate: ekEvent.startDate,
                                                  endDate: ekEvent.endDate)
        return objects(predicate: predicate).first ?? CalendarEvent(event: ekEvent)
    }
}
