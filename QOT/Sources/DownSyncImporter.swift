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
                    if let existing = try T.object(remoteID: remoteID, store: store, data: data) {
                        object = existing
                        object.createdAt = createdAt
                        object.modifiedAt = modifiedAt
                        try object.setData(data, objectStore: store)
                    } else {
                        try object = T.object(remoteID: remoteID, store: store, data: data, createdAt: createdAt, modifiedAt: modifiedAt)!
                    }
                case .deleted(let remoteID):
                    store.deleteObjects(T.self, predicate: NSPredicate(remoteID: remoteID))
                }
            } catch let error {
                log("Failed to import change: \(change), error: \(error)", level: .error)
            }
        }
    }
}
