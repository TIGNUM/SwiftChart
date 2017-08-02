//
//  UpSyncable.swift
//  QOT
//
//  Created by Sam Wyndham on 26.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

enum UpSyncStatus: Int {
    case clean = -1
    case created = 0
    case updated = 1
    case deleted = 2
}

protocol UpSyncable: class {

    var syncStatus: UpSyncStatus { get }

    func toJson() -> JSON?

    static var endpoint: Endpoint { get }

    static var dirtyPredicate: NSPredicate { get }

    static func upSyncData(realm: RealmProvider) throws -> UpSyncData?
}

extension UpSyncable where Self: Object {

    static func objectsAndJSONs(realm: Realm, max: Int = 50) -> [(Self, JSON)] {
        let objects = realm.objects(Self.self).filter(Self.dirtyPredicate).prefix(max)

        return objects.flatMap { (object) -> (Self, JSON)? in
            if let json = object.toJson(), object.syncStatus != .clean {
                return (object, json)
            } else {
                return nil
            }
        }
    }
}

// MARK: UpSyncableDeleting

protocol UpSyncableDeleting: UpSyncable {

    var localID: String { get }
}

extension UpSyncableDeleting where Self: SyncableObject {

    var syncStatus: UpSyncStatus {
        return .created
    }

    static var dirtyPredicate: NSPredicate {
        return NSPredicate(format: "TRUEPREDICATE")
    }

    static func upSyncData(realm: RealmProvider) throws -> UpSyncData? {
        let realm = try realm.realm()
        let items = objectsAndJSONs(realm: realm)
        if items.count == 0 {
            return nil
        }

        let completions = items.map { (object, _) -> (LocalIDToRemoteIDMap, Realm) -> Void in
            let localID = object.localID
            return { (map: LocalIDToRemoteIDMap, realm: Realm) in
                if let object = realm.syncableObject(ofType: Self.self, localID: localID) {
                    realm.delete(object)
                }
            }
        }

        return UpSyncData(body: try items.map { $0.1 }.toJSON().serialize()) { (localIDtoRemoteIDMap, realm) in
            completions.forEach { $0(localIDtoRemoteIDMap, realm) }
        }
    }
}

// MARK: UpSyncableWithLocalAndRemoteIDs

protocol UpSyncableWithLocalAndRemoteIDs: UpSyncable {

    var localChangeID: String? { get set }

    var localID: String { get }

    var remoteID: RealmOptional<Int> { get }

    var deleted: Bool { get set }
}

extension UpSyncableWithLocalAndRemoteIDs where Self: SyncableObject {

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

    static func upSyncData(realm: RealmProvider) throws -> UpSyncData? {
        let realm = try realm.realm()
        let items = objectsAndJSONs(realm: realm)
        if items.count == 0 {
            return nil
        }

        let completions = items.map { (object, _) -> (LocalIDToRemoteIDMap, Realm) throws -> Void in
            let localID = object.localID
            let changeID = object.localChangeID
            return { (map: LocalIDToRemoteIDMap, realm: Realm) in
                if let object = realm.syncableObject(ofType: Self.self, localID: localID), changeID == object.localChangeID {
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

        return UpSyncData(body: try items.map { $0.1 }.toJSON().serialize()) { (localIDtoRemoteIDMap, realm) in
            try completions.forEach { try $0(localIDtoRemoteIDMap, realm) }
        }
    }
}

// MARK: UpsyncableUnique

protocol UpsyncableUnique: UpSyncable {

    var localChangeID: String? { get set }
}

extension UpsyncableUnique where Self: Object {

    var syncStatus: UpSyncStatus {
        if localChangeID == nil {
            return .clean
        } else {
            return .updated
        }
    }

    static var dirtyPredicate: NSPredicate {
        return NSPredicate(format: "localChangeID != nil")
    }

    var dirty: Bool {
        get { return localChangeID != nil }
        set { localChangeID = newValue == true ? UUID().uuidString : nil }
    }

    static func upSyncData(realm: RealmProvider) throws -> UpSyncData? {
        let realm = try realm.realm()

        guard let json = realm.objects(Self.self).filter(Self.dirtyPredicate).first?.toJson() else {
            return nil
        }

        return UpSyncData(body: try json.serialize()) { (LocalIDToRemoteIDMap, Realm) in
            realm.objects(Self.self).first?.dirty = false
        }
    }
}
