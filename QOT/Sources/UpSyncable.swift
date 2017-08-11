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
    case createdLocally = 0 // does not exist on server
    case updatedLocally = 1 // does exist on server
    case deletedLocally = 2
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

protocol Dirty: class {

    var changeStamp: String? { get set }
}

extension Dirty {

    var dirty: Bool {
        get { return changeStamp != nil }
        set { changeStamp = newValue == true ? UUID().uuidString : nil }
    }

    func didUpdate() {
        dirty = true
    }
}

// MARK: UpSyncableDeleting

protocol UpSyncableDeleting: UpSyncable {

    var localID: String { get }
}

extension UpSyncableDeleting where Self: SyncableObject {

    var syncStatus: UpSyncStatus {
        return .createdLocally
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

protocol UpSyncableWithLocalAndRemoteIDs: UpSyncable, Dirty {

    var localID: String { get }

    var remoteID: RealmOptional<Int> { get }

    var deleted: Bool { get set }
}

extension UpSyncableWithLocalAndRemoteIDs where Self: SyncableObject {

    var syncStatus: UpSyncStatus {
        if changeStamp == nil {
            return .clean
        } else if deleted {
            return .deletedLocally
        } else if existsOnServer == false {
            return .createdLocally
        } else {
            return .updatedLocally
        }
    }

    static var dirtyPredicate: NSPredicate {
        return NSPredicate(format: "changeStamp != nil")
    }

    var existsOnServer: Bool {
        return remoteID.value != nil
    }

    static func upSyncData(realm: RealmProvider) throws -> UpSyncData? {
        let realm = try realm.realm()
        let items = objectsAndJSONs(realm: realm)
        if items.count == 0 {
            return nil
        }

        let completions = items.map { (object, _) -> (LocalIDToRemoteIDMap, Realm) throws -> Void in
            let localID = object.localID
            let previousChangeStamp = object.changeStamp
            return { (map: LocalIDToRemoteIDMap, realm: Realm) in
                if let object = realm.syncableObject(ofType: Self.self, localID: localID),
                    previousChangeStamp == object.changeStamp {
                    switch object.syncStatus {
                    case .clean:
                        break
                    case .createdLocally:
                        guard let remoteID = map[object.localID] else {
                            throw SimpleError(localizedDescription: "No remote ID for object: \(object)")
                        }

                        object.setRemoteIDValue(remoteID)
                        object.dirty = false
                    case .updatedLocally:
                        object.dirty = false
                    case .deletedLocally:
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

protocol UpsyncableUnique: UpSyncable, Dirty {

}

extension UpsyncableUnique where Self: Object {

    var syncStatus: UpSyncStatus {
        if changeStamp == nil {
            return .clean
        } else {
            return .updatedLocally
        }
    }

    static var dirtyPredicate: NSPredicate {
        return NSPredicate(format: "changeStamp != nil")
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

// MARK: UpSyncableMedia

protocol UpSyncableMedia: class {
    
    var localURLString: String? { get set }
    
    var remoteURLString: String? { get set }
    
    var syncStatus: UpSyncStatus { get }
    
    func toJson() -> JSON?
    
    static var endpoint: Endpoint { get }
    
    static var dirtyPredicate: NSPredicate { get }
    
    func upSyncData(realm: RealmProvider) throws -> UpSyncMediaData?
}

extension UpSyncableMedia where Self: SyncableObject {
    var syncStatus: UpSyncStatus {
        if localURLString == nil {
            return .clean
        } else {
            return .updatedLocally
        }
    }
    
    static var dirtyPredicate: NSPredicate {
        return NSPredicate(format: "localURLString != nil")
    }
    
    func upSyncData(realm: RealmProvider) throws -> UpSyncMediaData? {
        if let json = toJson(), syncStatus != .clean {
            return UpSyncMediaData(body: try json.serialize())
        } else {
            return nil
        }
    }
}

// MARK: UpsyncableUpdateOnly

protocol UpsyncableUpdateOnly: UpSyncable, Dirty {}

extension UpsyncableUpdateOnly where Self: SyncableObject {

    var syncStatus: UpSyncStatus {
        return dirty ? .updatedLocally : .clean
    }

    static var dirtyPredicate: NSPredicate {
        return NSPredicate(format: "changeStamp != nil")
    }

    static func upSyncData(realm: RealmProvider) throws -> UpSyncData? {
        let realm = try realm.realm()
        let items = objectsAndJSONs(realm: realm)
        if items.count == 0 {
            return nil
        }

        let completions = items.map { (object, _) -> (LocalIDToRemoteIDMap, Realm) throws -> Void in
            let localID = object.localID
            let previousChangeStamp = object.changeStamp
            return { (map: LocalIDToRemoteIDMap, realm: Realm) in
                if let object = realm.syncableObject(ofType: Self.self, localID: localID),
                    previousChangeStamp == object.changeStamp {
                    object.dirty = false
                }
            }
        }

        return UpSyncData(body: try items.map { $0.1 }.toJSON().serialize()) { (localIDtoRemoteIDMap, realm) in
            try completions.forEach { try $0(localIDtoRemoteIDMap, realm) }
        }
    }
}
