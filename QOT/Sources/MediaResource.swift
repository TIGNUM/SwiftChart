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

    var url: URL? {
        // We must always prefer localURL over remtoteURL. Once a local image has been uploaded localURL is set to nil.
        return localURL ?? remoteURL
    }

    func setLocalURL(_ localURL: URL, format: Format, entity: Entity, entitiyLocalID: String) {
        assert(localURL.baseURL == URL.imageDirectory, "localURL baseURL must be image directory")

        self.localFileName = localURL.relativePath
        self.format = format.rawValue
        self.entity = entity.rawValue
        self.entitiyLocalID = entitiyLocalID
    }

    /// Updates `remoteURLString` if there is no `request`.
    func setRemoteURL(_ remoteURL: URL?) {
        if localFileName == nil {
            remoteURLString = remoteURL?.absoluteString
        }
    }

    /// Updates `remoteURLString` and deletes `request`. Should be called after uploading media successfully.
    func uploadComplete(remoteURL: URL) {
        remoteURLString = remoteURL.absoluteString
        localFileName = nil
        format = nil
        entity = nil
        entitiyLocalID = nil
    }

    func json() -> JSON? {
        guard
            let entityRemoteID = entityRemoteID,
            let local = localURL,
            let format = format,
            let entity = entity else { return nil }

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

        let dict: [JsonKey: JSONEncodable] = [
            .qotId: localID,
            .mediaFormat: format,
            .idOfRelatedEntity: entityRemoteID,
            .mediaEntity: entity,
            .base64Data: byteArray.toJSON()
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }

    var localURL: URL? {
        return localFileName.flatMap { URL(fileURLWithPath: $0, relativeTo: URL.imageDirectory) }
    }

    var remoteURL: URL? {
        return remoteURLString.flatMap { URL(string: $0)}
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
