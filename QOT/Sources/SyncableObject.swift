//
//  SyncableObject.swift
//  QOT
//
//  Created by Sam Wyndham on 01.08.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import RealmSwift

class SyncableObject: Object {

    dynamic var localID: String = UUID().uuidString

    let remoteID = RealmOptional<Int>(nil)
    
    dynamic var createdAt: Date = Date()

    dynamic var modifiedAt: Date = Date()

    final override class func primaryKey() -> String? {
        return "localID"
    }

    final override class func indexedProperties() -> [String] {
        return ["remoteID"] + additionalIndexedProperties()
    }

    class func additionalIndexedProperties() -> [String] {
        return []
    }

    final func setRemoteIDValue(_ value: Int) {
        remoteID.value = value
        didSetRemoteID()
    }

    // @note we use didSetRemoteID() as using an inverse relationship to a base class (e.g. SyncableObject) doesn't pick superclass changes to remoteID
    func didSetRemoteID() {

    }

    // FIXME: This should be part of a protocol and only applied to types which a only created server side.
    final var forcedRemoteID: Int {
        return remoteID.value!
    }
}
