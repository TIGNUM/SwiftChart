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

    func recordSync<T>(_ type: T.Type, date: Int64) throws {
        let realm = try realmProvider.realm()
        let className = String(describing: T.self)
        try realm.write {
            let record = SyncRecord(associatedClassName: className, date: date)
            realm.create(SyncRecord.self, value: record, update: true)
        }
    }

    func lastSync<T>(_ type: T.Type) throws -> Int64? {
        let realm = try realmProvider.realm()
        let className = String(describing: T.self)
        if let savedDate = realm.object(ofType: SyncRecord.self, forPrimaryKey: className)?.date {
            return savedDate
        }
        return minimumInitialSyncDate(type)
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

    // FIXME: Hack so we just fetch limited UserAnswers
    private func minimumInitialSyncDate<T>(_ type: T.Type) -> Int64? {
        if type == UserAnswer.self {
            return Int64(Date(timeIntervalSinceNow: -TimeInterval(days: 7)).timeIntervalSince1970) * 1000 // 7 Days ago
        }
        return nil
    }
}
