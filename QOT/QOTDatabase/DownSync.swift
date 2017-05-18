//
//  DownSyncable.swift
//  Pods
//
//  Created by Sam Wyndham on 10/05/2017.
//
//

import Foundation
import RealmSwift

public protocol DownSyncable: class {
    associatedtype Data

    static func make(remoteID: Int, createdAt: Date) -> Self

    var modifiedAt: Date { get set }

    func setData(_ data: Data, objectStore: ObjectStore) throws
}

public enum DownSyncChange<T: DownSyncable> {
    case createdOrUpdated(remoteID: Int, createdAt: Date, modifiedAt: Date, data: T.Data)
    case deleted(remoteID: Int)
}

// Down Sync should always occur after a recent Up Sync. This allows us a level of pragmatism - we will treat what comes
// from the server as a single source of truth and overwrite local data without concern for merge conflicts.

public struct DownSyncTask<T> where T: DownSyncable, T: Object {

    func sync(changes: [DownSyncChange<T>], store: ObjectStore) throws {
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
