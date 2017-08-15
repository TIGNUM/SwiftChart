//
//  SyncRecordService.swift
//  QOT
//
//  Created by Sam Wyndham on 29.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import RealmSwift

final class SyncRecordService {

    private let realmProvider: RealmProvider

    init(realmProvider: RealmProvider) {
        self.realmProvider = realmProvider
    }

    func recordSync(className: String, date: Int64) throws {
        let realm = try realmProvider.realm()
        try realm.write {
            let record = SyncRecord(associatedClassName: className, date: date)
            realm.create(SyncRecord.self, value: record, update: true)
        }
    }

    func lastSync(className: String) throws -> Int64 {
        let realm = try realmProvider.realm()
        return realm.object(ofType: SyncRecord.self, forPrimaryKey: className)?.date ?? 0
    }
    
    func deleteSyncRecordsForClassNames(_ names: [String]) throws {
        let realm = try realmProvider.realm()
        try names.forEach { (name: String) in
            let objects = realm.objects(SyncRecord.self).filter(NSPredicate(format: "%K == %@", "associatedClassName", name))
            try realm.write {
                realm.delete(objects)
            }
        }
    }
}
