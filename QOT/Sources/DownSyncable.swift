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

    static func object(remoteID: Int, store: ObjectStore) throws -> Self?
}

extension DownSyncable where Self: SyncableObject {

    static func object(remoteID: Int, store: ObjectStore) -> Self? {
        return store.syncableObject(ofType: Self.self, remoteID: remoteID)
    }
}
