//
//  SyncStateObserver.swift
//  QOT
//
//  Created by Sam Wyndham on 26.10.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers final class SyncStateObserver {

    private let syncRecords: Results<SyncRecord>
    private var token: NotificationToken?
    private(set) dynamic var syncedClasses: Set<String> {
        didSet {
            updateClosure?(self)
        }
    }
    private var updateClosure: ((SyncStateObserver) -> Void)?

    init(realm: Realm) {
        let syncRecords = realm.objects(SyncRecord.self)
        self.syncRecords = syncRecords
        self.syncedClasses = syncRecords.classNames

        token = syncRecords.observe { [unowned self] (change) in
            switch change {
            case .initial(let syncRecords):
                self.syncedClasses = syncRecords.classNames
            case .update(let syncRecords, let deletions, let insertions, _):
                if deletions.count > 0 || insertions.count > 0 {
                    self.syncedClasses = syncRecords.classNames
                }
            case .error:
                break
            }
        }
    }

    func hasSynced<T>(_ type: T.Type) -> Bool {
        return syncedClasses.contains(String(describing: type))
    }

    func onUpdate(closure: @escaping (SyncStateObserver) -> Void) {
        updateClosure = closure
    }
}

// MARK: Helpers

private extension Results where Element: SyncRecord {

    var classNames: Set<String> {
        return Set(map({ $0.associatedClassName }))
    }
}
