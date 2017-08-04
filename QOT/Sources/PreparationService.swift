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

    func createPreparation(contentID: Int, eventID: String?, title: String, subtitle: String, completion: ((Error?, String?) -> Void)?) {
        DispatchQueue.global().async {
            var localID: String?
            do {
                let realm = try self.realmProvider.realm()
                var calendarEvent: CalendarEvent?
                if let eventID = eventID {
                    calendarEvent = realm.calendarEventForEventID(eventID)
                }
                
                try realm.write {
                    let preparation = Preparation(contentID: contentID, calendarEvent: calendarEvent, title: title, subtitle: subtitle)
                    localID = preparation.localID
                    realm.add(preparation)
                }
                DispatchQueue.main.async {
                    completion?(nil, localID)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion?(error, nil)
                }
            }
        }
    }

    /// Updates `PreparationCheck`s for a `Preparation.localID`. `checks` is a map of `ContentItem.remoteID` to check date.
    func updateChecks(preparationID: String, checks: [Int: Date], completion: ((Error?) -> Void)?) {
        DispatchQueue.global().async {
            do {
                let realm = try self.realmProvider.realm()
                let currentChecks: AnyRealmCollection<PreparationCheck> = realm.anyCollection(predicates: .preparationID(preparationID))
                var newChecks = checks

                try realm.write {
                    for check in currentChecks {
                        if newChecks[check.contentItemID] == nil {
                            check.delete()
                        } else {
                            newChecks[check.contentItemID] = nil
                        }
                    }
                    for check in newChecks {
                        realm.add(PreparationCheck(preparationID: preparationID, contentItemID: check.key, timestamp: check.value))
                    }
                }
                DispatchQueue.main.async {
                    completion?(nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion?(error)
                }
            }
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
