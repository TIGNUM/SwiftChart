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

    func recordSync(type: SyncType, date: Int64) throws {
        let realm = try realmProvider.realm()
        try realm.write {
            let record = SyncRecord(type: type, date: date)
            realm.create(SyncRecord.self, value: record, update: true)
        }
    }

    func lastSync(type: SyncType) throws -> Int64 {
        let realm = try realmProvider.realm()
        return realm.object(ofType: SyncRecord.self, forPrimaryKey: type.rawValue)?.date ?? 0
    }
}
