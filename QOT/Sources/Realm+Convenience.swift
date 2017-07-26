//
//  Realm+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 21.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {

    func anyCollection<T, K>(primaryKey: K) -> T? where T : RealmSwift.Object {
        return object(ofType: T.self, forPrimaryKey: primaryKey)
    }

    func anyCollection<T>(_ sort: SortDescriptor? = nil, predicates: NSPredicate...) -> AnyRealmCollection<T> {
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        if let sort = sort {
            return AnyRealmCollection(objects(T.self).sorted(by: [sort]).filter(predicate))
        }

        return AnyRealmCollection(objects(T.self).filter(predicate))
    }

    func object<T, K>(primaryKey: K) throws -> T where T : RealmSwift.Object {
        guard let object = object(ofType: T.self, forPrimaryKey: primaryKey) else {
            throw DatabaseError.objectNotFound(primaryKey: primaryKey)
        }
        return object
    }

    func objects<T: Object, K>(ofType type: T.Type, forPrimaryKeys keys: [K]) -> [T] {
        return keys.flatMap { (key) -> T? in
            return object(ofType: T.self, forPrimaryKey: key)
        }
    }

    func objects<T>(predicate: NSPredicate? = nil) -> Results<T> {
        if let predicate = predicate {
            return objects(T.self).filter(predicate)
        } else {
            return objects(T.self)
        }
    }
}
