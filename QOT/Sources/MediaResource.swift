//
//  MediaResource.swift
//  QOT
//
//  Created by Lee Arromba on 04/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import RealmSwift
import Freddy

final class MediaResource: Object {

    enum Entity: String {
        case partner = "QOTPARTNER"
        case toBeVision = "TOBEVISION"
        case user = "USER"
    }

    enum Format: String {
        case png = "PNG"
        case jpg = "JPG"
    }

    @objc private(set) dynamic var localID: String = UUID().uuidString

    @objc private dynamic var remoteURLString: String?

    @objc private dynamic var localFileName: String?

    @objc private dynamic var format: String?

    @objc private dynamic var entity: String?

    @objc private dynamic var entitiyLocalID: String?

    final override class func primaryKey() -> String? {
        return "localID"
    }

    let remoteID = RealmOptional<Int>(nil)

    final func setRemoteIDValue(_ value: Int) {
        remoteID.value = value
        didSetRemoteID()
    }

    // @note we use didSetRemoteID() as using an inverse relationship to a base class (e.g. SyncableObject) doesn't pick superclass changes to remoteID
    func didSetRemoteID() {

    }

    var url: URL? {
        // We must always prefer localURL over remtoteURL. Once a local image has been uploaded localURL is set to nil.
        if syncStatusValue.value == UpSyncStatus.deletedLocally.rawValue {
            return nil
        }
        return localURL ?? remoteURL
    }

    let syncStatusValue = RealmOptional<Int>(UpSyncStatus.clean.rawValue)

    var syncStatus: UpSyncStatus {
        return UpSyncStatus(rawValue: syncStatusValue.value ?? -1) ?? .clean
    }

    func delete() {
        syncStatusValue.value = UpSyncStatus.deletedLocally.rawValue

        if let localImageURL = localURL {
            do {
                try FileManager.default.removeItem(at: localImageURL)
            } catch {
                //
            }
            localFileName = nil
            entitiyLocalID = nil
        }
    }

    func setLocalURL(_ localURL: URL, format: Format, entity: Entity, entitiyLocalID: String) {
        assert(localURL.isLocalImageDirectory(), "localURL baseURL must be image directory")
        self.remoteID.value = nil
        self.localFileName = localURL.relativePath
        self.format = format.rawValue
        self.entity = entity.rawValue
        self.entitiyLocalID = entitiyLocalID
        self.syncStatusValue.value = UpSyncStatus.createdLocally.rawValue
    }

    /// Updates `remoteURLString` if there is no `request`.
    func setRemoteURL(_ remoteURL: URL?) {
        if localFileName == nil {
            remoteURLString = remoteURL?.absoluteString
        }
    }

    /// Updates `remoteURLString` and deletes `request`. Should be called after uploading media successfully.
    func uploadComplete(remoteID: Int, remoteURL: URL) {
        remoteURLString = syncStatus == .deletedLocally ? nil : remoteURL.absoluteString
        localFileName = nil
        entitiyLocalID = nil
        self.remoteID.value = syncStatus == .deletedLocally ? nil : remoteID
        didSetRemoteID()
        syncStatusValue.value = UpSyncStatus.clean.rawValue
    }

    func setData(_ data: MediaResourceIntermediary) {
        remoteID.value = data.remoteID
        setRemoteURL(URL(string: data.mediaUrl ?? ""))
        format = data.mediaFormat
        entitiyLocalID = nil
        entity = MediaEntryType(rawValue: data.entryType ?? "")?.mediaEntityType.rawValue
        syncStatusValue.value = UpSyncStatus.clean.rawValue
    }

    func json() -> JSON? {
        guard
            let entity = entity else { return nil }

        var dict: [JsonKey: JSONEncodable] = [
            .qotId: localID,
            .mediaEntity: entity,
            .syncStatus: syncStatus.rawValue
        ]

        if let entityRemoteID = entityRemoteID {
            dict[.idOfRelatedEntity] = entityRemoteID
        }
        if let format = format {
            dict[.mediaFormat] = format
        }

        if let remoteIDValue = self.remoteID.value {
            dict[.id] = remoteIDValue
        }

        if let local = localURL {
            var byteArray = [Int]()
            do {
                let data = try Data(contentsOf: local)
                byteArray = data.withUnsafeBytes({ (pointer: UnsafePointer<UInt8>) -> [Int] in
                    var bytes = [Int]()
                    let max = data.count
                    for i in (0..<max) {
                        bytes.append(Int(pointer[i]))
                    }
                    return bytes
                })
            } catch {
                return nil
            }
            dict[.base64Data] = byteArray.toJSON()
        }

        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }

    var localURL: URL? {
        return localFileName.flatMap { URL(fileURLWithPath: $0, relativeTo: URL.imageDirectory) }
    }

    var remoteURL: URL? {
        return remoteURLString.flatMap { URL(string: $0)}
    }

    var entityType: Entity {
        return Entity(rawValue: entity ?? "") ?? .partner
    }

    private var entityRemoteID: Int? {
        guard
            let entity = entity.flatMap({ Entity(rawValue: $0) }),
            let entityLocalID = entitiyLocalID,
            let realm = realm else { return nil }

        switch entity {
        case .partner:
            return realm.syncableObject(ofType: Partner.self, localID: entityLocalID)?.remoteID.value
        case .toBeVision:
            return realm.syncableObject(ofType: MyToBeVision.self, localID: entityLocalID)?.remoteID.value
        case .user:
            return realm.syncableObject(ofType: User.self, localID: entityLocalID)?.remoteID.value
        }
    }
}
