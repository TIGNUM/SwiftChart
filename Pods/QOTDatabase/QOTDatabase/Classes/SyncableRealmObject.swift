//
//  SyncableRealmObject.swift
//  Pods
//
//  Created by Sam Wyndham on 07/04/2017.
//
//

import Foundation
import RealmSwift

public protocol SyncableRealmObject: Syncable {
    /// - warning: This property is for internal use and should not be accessed directly.
    var _remoteID: RealmOptional<Int> { get }
    /// - warning: This property is for internal use and should not be accessed directly.
    var _syncStatus: Int8 { get set }
}

extension SyncableRealmObject {

    public var remoteID: Int? {
        get { return _remoteID.value }
        set { _remoteID.value = newValue }
    }

    public var syncStatus: SyncStatus {
        get {
            guard let syncStatus = SyncStatus(rawValue: _syncStatus) else {
                fatalError("Invalid state: \(self)")
            }
            return syncStatus
        }
        set { _syncStatus = newValue.rawValue }
    }
}
