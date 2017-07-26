//
//  UpSyncable.swift
//  QOT
//
//  Created by Sam Wyndham on 26.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

enum UpSyncStatus: Int {
    case clean = -1
    case created = 0
    case updated = 1
    case deleted = 2
}

protocol UpSyncable: class {

    var syncStatus: UpSyncStatus { get }

    func completeUpSync() -> (LocalIDToRemoteIDMap, Realm) throws -> Void

    static var endpoint: Endpoint { get }

    static var dirtyPredicate: NSPredicate { get }
}

protocol UpSyncableDeleting: UpSyncable {

    var localID: String { get }
}

extension UpSyncableDeleting where Self: Object {

    var syncStatus: UpSyncStatus {
        return .created
    }

    func completeUpSync() -> (LocalIDToRemoteIDMap, Realm) throws -> Void {
        let localID = self.localID
        return { (map: LocalIDToRemoteIDMap, realm: Realm) in
            if let object = realm.object(ofType: Self.self, forPrimaryKey: localID) {
                realm.delete(object)
            }
        }
    }

    static var dirtyPredicate: NSPredicate {
        return NSPredicate(format: "TRUEPREDICATE")
    }
}

protocol UpSyncableWithLocalAndRemoteIDs: UpSyncable {

    var localChangeID: String? { get set }

    var localID: String { get }

    var remoteID: RealmOptional<Int> { get }

    var deleted: Bool { get set }
}

extension UpSyncableWithLocalAndRemoteIDs where Self: Object {

    var syncStatus: UpSyncStatus {
        if localChangeID == nil {
            return .clean
        } else if deleted {
            return .deleted
        } else if existsOnServer == false {
            return .created
        } else {
            return .updated
        }
    }

    static var dirtyPredicate: NSPredicate {
        return NSPredicate(format: "localChangeID != nil")
    }

    var existsOnServer: Bool {
        return remoteID.value != nil
    }

    var dirty: Bool {
        get { return localChangeID != nil }
        set { localChangeID = newValue == true ? UUID().uuidString : nil }
    }

    func completeUpSync() -> (LocalIDToRemoteIDMap, Realm) throws -> Void {
        let localID = self.localID
        let changeID = localChangeID
        return { (map: LocalIDToRemoteIDMap, realm: Realm) in
            if let object = realm.object(ofType: Self.self, forPrimaryKey: localID), changeID == object.localChangeID {
                switch object.syncStatus {
                case .clean:
                    break
                case .created:
                    guard let remoteID = map[object.localID] else {
                        throw SimpleError(localizedDescription: "No remote ID for object: \(object)")
                    }

                    object.remoteID.value = remoteID
                    object.dirty = false
                case .updated:
                    object.dirty = false
                case .deleted:
                    realm.delete(object)
                }
            }
        }
    }
}
