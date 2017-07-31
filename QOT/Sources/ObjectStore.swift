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
    case objectNotFound(predicate: NSPredicate)
}

protocol ObjectStore {

    func uniqueObject<T: Object>(_ type: T.Type, predicate: NSPredicate) throws -> T?

    func uniqueObjects<T: Object>(_ type: T.Type, predicates: [NSPredicate]) throws -> [T]

    func addObject(_ object: Object)

    func deleteObjects<T: Object>(_ type: T.Type, predicate: NSPredicate)

    func write(_ block: (() throws -> Void)) throws

    func delete<T: Object>(_ objects: List<T>)

    func objects<T: Object>(_ type: T.Type) -> Results<T>
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

    func uniqueObjects<T: Object>(_ type: T.Type, predicates: [NSPredicate]) throws -> [T] {
        return try predicates.map { (predicate) -> T in
            guard let object = try uniqueObject(type, predicate: predicate) else {
                throw ObjectStoreError.objectNotFound(predicate: predicate)
            }
            return object
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
