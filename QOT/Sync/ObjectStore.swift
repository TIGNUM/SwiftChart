//
//  ObjectStore.swift
//  Pods
//
//  Created by Sam Wyndham on 10/05/2017.
//
//

import Foundation
import RealmSwift

enum ObjectStoreError: Error {
    case objectIsNotUnique
}

protocol ObjectStore {

    func uniqueObject<T: Object>(_ type: T.Type, predicate: NSPredicate) throws -> T?

    func addObject(_ object: Object)

    func deleteObjects<T: Object>(_ type: T.Type, predicate: NSPredicate)

    func write(_ block: (() throws -> Void)) throws
}

extension Realm: ObjectStore {

    func uniqueObject<T: Object>(_ type: T.Type, predicate: NSPredicate) throws -> T? {
        let objs = objects(type).filter(predicate)
        switch objs.count {
        case 0:
            return nil
        case 1:
            return objs[0]
        default:
            throw ObjectStoreError.objectIsNotUnique
        }
    }

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
