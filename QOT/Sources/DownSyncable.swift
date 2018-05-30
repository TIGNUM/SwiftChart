//
//  DownSyncable.swift
//  Pods
//
//  Created by Sam Wyndham on 10/05/2017.
//
//

import Foundation
import RealmSwift

protocol DownSyncable: Syncable {
    associatedtype Data

    var modifiedAt: Date { get set }

    func setData(_ data: Data, objectStore: ObjectStore) throws

    static func object(remoteID: Int, store: ObjectStore, data: Data) throws -> Self?

    static func object(remoteID: Int, store: ObjectStore, data: Data, createdAt: Date, modifiedAt: Date) throws -> Self?
}

extension DownSyncable where Self: SyncableObject {

    static func object(remoteID: Int, store: ObjectStore, data: Data) -> Self? {
        let obj = store.syncableObject(ofType: Self.self, remoteID: remoteID)
        if obj == nil { return nil }
        obj?.setRemoteIDValue(remoteID)
        do {
            try obj?.setData(data, objectStore: store)
        } catch {
            // Do nothing
        }
        return obj
    }

    static func object(remoteID: Int, store: ObjectStore, data: Data, createdAt: Date, modifiedAt: Date) -> Self? {
        let obj = Self()
        obj.createdAt = createdAt
        obj.modifiedAt = modifiedAt
        obj.setRemoteIDValue(remoteID)
        do {
            try obj.setData(data, objectStore: store)
        } catch {
            // Do nothing
        }
        store.addObject(obj)
        return obj
    }
}
