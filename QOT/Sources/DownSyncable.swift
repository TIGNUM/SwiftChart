//
//  DownSyncable.swift
//  Pods
//
//  Created by Sam Wyndham on 10/05/2017.
//
//

import Foundation
import RealmSwift

protocol DownSyncable: class {
    associatedtype Data

    static func make(remoteID: Int, createdAt: Date) -> Self

    var modifiedAt: Date { get set }

    func setData(_ data: Data, objectStore: ObjectStore) throws

    static func object(remoteID: Int, store: ObjectStore) throws -> Self?
}

extension DownSyncable where Self: SyncableObject {

    static func object(remoteID: Int, store: ObjectStore) throws -> Self? {
        return try store.uniqueObject(Self.self, predicate: NSPredicate(remoteID: remoteID))
    }

    static func make(remoteID: Int, createdAt: Date) -> Self {
        let object = Self()
        object.remoteID.value = remoteID
        object.createdAt = createdAt
        return object
    }
}
