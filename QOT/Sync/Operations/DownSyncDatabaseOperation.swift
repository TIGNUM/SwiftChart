//
//  DownSyncDatabaseOperation.swift
//  QOT
//
//  Created by Sam Wyndham on 29.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class DownSyncDatabaseOperation<T>: Operation where T: DownSyncable, T: Object {

    private let context: SyncContext
    private let syncType: SyncType
    private let storeProvider: ObjectStoreProvider

    init(context: SyncContext, syncType: SyncType, storeProvider: ObjectStoreProvider) {
        self.context = context
        self.syncType = syncType
        self.storeProvider = storeProvider
        super.init()
    }

    override func main() {
        guard let result = context.data[syncType.rawValue] as? DownSyncNetworkResult<T.Data> else {
            preconditionFailure("No results")
        }

        let changes = result.changes
        do {
            let store = try storeProvider.store()
            let task = DownSyncTask<T>()
            try task.sync(changes: changes, store: store)
        } catch let error {
            context.syncFailed(error: error)
        }
    }
}

// MARK: Private helpers

private struct DownSyncTask<T> where T: DownSyncable, T: Object {

    func sync(changes: [DownSyncChange<T.Data>], store: ObjectStore) throws {
        for change in changes {
            switch change {
            case .createdOrUpdated(let remoteID, let createdAt, let modifiedAt, let data):
                let object: T
                if let existing = try store.uniqueObject(T.self, predicate: NSPredicate(remoteID: remoteID)) {
                    object = existing
                } else {
                    object = T.make(remoteID: remoteID, createdAt: createdAt)
                    store.addObject(object)
                }

                object.modifiedAt = modifiedAt
                try object.setData(data, objectStore: store)
            case .deleted(let remoteID):
                store.deleteObjects(T.self, predicate: NSPredicate(remoteID: remoteID))
            }
        }
    }
}

