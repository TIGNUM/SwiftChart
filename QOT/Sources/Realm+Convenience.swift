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

    public func transactionSafeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }

    func syncableObjects<T: SyncableObject>(ofType type: T.Type, remoteIDs: [Int]) -> [T] {
        return remoteIDs.compactMap { (remoteIDs) -> T? in
            return syncableObject(ofType: T.self, remoteID: remoteIDs)
        }
    }

    func syncableObject<T: SyncableObject>(ofType type: T.Type, localID: String) -> T? {
        return object(ofType: type, forPrimaryKey: localID)
    }

    func syncableObject<T: SyncableObject>(ofType type: T.Type, remoteID: Int) -> T? {
        let objs = objects(type).filter("remoteID == %d", remoteID).sorted(byKeyPath: "modifiedAt", ascending: false)
        let object = objs.first

        // MARK: Cleanup. These object should be unique so delete additional.
        if objs.count > 1 {
            print(type)
            assertionFailure("There should be no objects with duplicate remoteIDs")

            let needsDeleting = Array(objs.dropFirst())
            do {
                if isInWriteTransaction {
                    delete(needsDeleting)
                } else {
                    try write {
                        delete(needsDeleting)
                    }
                }
            } catch let error {
                assertionFailure("Unable to delete objects with duplicate remoteIDs: \(error)")
            }
        }
        return object
    }
}
