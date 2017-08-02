//
//  DownSyncImporter.swift
//  QOT
//
//  Created by Sam Wyndham on 02.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

class DownSyncImporter<T> where T: DownSyncable, T: SyncableObject {

    func importChanges(_ changes: [DownSyncChange<T.Data>], store: ObjectStore) throws {
        for change in changes {
            do {
                switch change {
                case .createdOrUpdated(let remoteID, let createdAt, let modifiedAt, let data):
                    let object: T
                    if let existing = try T.object(remoteID: remoteID, store: store) {
                        object = existing
                    } else {
                        object = T()
                        object.remoteID.value = remoteID
                        object.createdAt = createdAt
                        store.addObject(object)
                    }

                    object.modifiedAt = modifiedAt
                    try object.setData(data, objectStore: store)
                case .deleted(let remoteID):
                    store.deleteObjects(T.self, predicate: NSPredicate(remoteID: remoteID))
                }
            } catch let error {
                print("Failed to import change: \(change), error: \(error)")
            }
        }
    }
}
