//
//  PreparationService.swift
//  QOT
//
//  Created by Sam Wyndham on 27.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import RealmSwift

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

    func preparationChecks(preparationID: String) -> AnyRealmCollection<PreparationCheck> {
        return mainRealm.anyCollection(predicates: .preparationID(preparationID))
    }

    func createPreparation(contentID: Int, eventID: String?, completion: @escaping (Error?) -> Void) {
        DispatchQueue.global().async {
            do {
                let realm = try self.realmProvider.realm()
                try realm.write {
                    realm.add(Preparation(contentID: contentID, eventID: eventID))
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }

    /// Updates `PreparationCheck`s for a `Preparation.localID`. `checks` is a map of `ContentItem.remoteID` to check date.
    func updateChecks(preparationID: String, checks: [Int: Date], completion: @escaping (Error?) -> Void) {
        DispatchQueue.global().async {
            do {
                let realm = try self.realmProvider.realm()
                let currentChecks: AnyRealmCollection<PreparationCheck> = realm.anyCollection(predicates: .preparationID(preparationID))
                var newChecks = checks

                try realm.write {
                    for check in currentChecks {
                        if newChecks[check.contentItemID] == nil {
                            realm.delete(check)
                        } else {
                            newChecks[check.contentItemID] = nil
                        }
                    }
                    for check in newChecks {
                        realm.add(PreparationCheck(preparationID: preparationID, contentItemID: check.key, timestamp: check.value))
                    }
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
}
