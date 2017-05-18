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

public protocol ObjectStore {

    func uniqueObject<T: Object>(_ type: T.Type, predicate: NSPredicate) throws -> T?

    func addObject(_ object: Object)

    func deleteObjects<T: Object>(_ type: T.Type, predicate: NSPredicate)
}

extension Realm: ObjectStore {

    public func uniqueObject<T: Object>(_ type: T.Type, predicate: NSPredicate) throws -> T? {
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

    public func addObject(_ object: Object) {
        add(object, update: false)
    }

    public func deleteObjects<T: Object>(_ type: T.Type, predicate: NSPredicate) {
        delete(objects(type).filter(predicate))
    }
}
