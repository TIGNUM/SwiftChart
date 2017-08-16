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

    func preparationsOnBackground() throws -> AnyRealmCollection<Preparation> {
        return try realmProvider.realm().anyCollection()
    }

    func preparationChecksOnBackground(preparationID: String) throws -> AnyRealmCollection<PreparationCheck> {
        return try realmProvider.realm().preparationChecks(preparationID: preparationID)
    }

    func createPreparation(contentCollectionID: Int, eventID: String?, name: String, subtitle: String) throws -> String {
        let realm = try self.realmProvider.realm()
        guard let contentCollection = realm.syncableObject(ofType: ContentCollection.self, remoteID: contentCollectionID) else {
            throw SimpleError(localizedDescription: "No content collection for contentCollectionID: \(contentCollectionID)")
        }
        
        var calendarEvent: CalendarEvent?
        if let eventID = eventID {
            calendarEvent = realm.calendarEventForEventID(eventID)
        }
        
        let preparation = Preparation(calendarEvent: calendarEvent, contentCollectionID: contentCollectionID, name: name, subtitle: subtitle)
        let items = contentCollection.items.filter ({ (item: ContentItem) -> Bool in
            switch item.contentItemValue {
            case .prepareStep:
                return true
            default:
                return false
            }
        })
        items.forEach({ (item: ContentItem) in
            preparation.checks.append(PreparationCheck(preparation: preparation, contentItem: item, covered: nil))
        })
        try realm.write {
            realm.add(preparation)
        }
        return preparation.localID
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
    
    func calendarEventForEventID(_ eventID: String) -> CalendarEvent? {
        var calendarEvent = syncableObject(ofType: CalendarEvent.self, localID: eventID)
        if calendarEvent == nil {
            let store = EKEventStore()
            if let event = store.event(withIdentifier: eventID) {
                calendarEvent = CalendarEvent(event: event)
            }
        }
        return calendarEvent
    }
}
