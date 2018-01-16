//
//  ObjectStore.swift
//  Pods
//
//  Created by Sam Wyndham on 10/05/2017.
//
//

import Foundation
import RealmSwift

protocol ObjectStore {

    func addObject(_ object: Object)

    func deleteObjects<T: Object>(_ type: T.Type, predicate: NSPredicate)

    func write(_ block: (() throws -> Void)) throws

    func delete<T>(_ objects: List<T>)

    func objects<T: Object>(_ type: T.Type) -> Results<T>

    func syncableObject<T: SyncableObject>(ofType type: T.Type, remoteID: Int) -> T?

    func object<T: Object, K>(ofType type: T.Type, forPrimaryKey key: K) -> T?
}

extension Realm: ObjectStore {

    func addObject(_ object: Object) {
        add(object, update: false)
    }

    func deleteObjects<T: Object>(_ type: T.Type, predicate: NSPredicate) {
        delete(objects(type).filter(predicate))
    }
}

protocol ObjectStoreProvider {
    func store() throws -> ObjectStore
}

extension RealmProvider: ObjectStoreProvider {
    func store() throws -> ObjectStore {
        return try realm()
    }
}
