//
//  MediaResource.swift
//  QOT
//
//  Created by Lee Arromba on 04/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import RealmSwift
import Freddy

class MediaResource: SyncableObject {
    dynamic var localURLString: String?
    dynamic var remoteURLString: String?
    dynamic var mediaFormat: String = ""
    dynamic var mediaEntity: String = ""
    let relatedEntityID = RealmOptional<Int>(nil)
    
    var localURL: URL? {
        if let localURLString = localURLString {
            return URL(string: localURLString)
        }
        return nil
    }
    var remoteURL: URL? {
        if let remoteURLString = remoteURLString {
            return URL(string: remoteURLString)
        }
        return nil
    }
    var isAvailable: Bool {
        return (localURLString != nil || remoteURLString != nil)
    }
    
    convenience init(localURLString: String?, remoteURLString: String?, relatedEntityID: Int?, mediaFormat: String, mediaEntity: String) {
        self.init()
        
        self.localURLString = localURLString
        self.remoteURLString = remoteURLString
        self.relatedEntityID.value = relatedEntityID
        self.mediaFormat = mediaFormat
        self.mediaEntity = mediaEntity
    }
}

// MARK: - OneWaySyncableUp

extension MediaResource: OneWayMediaSyncableUp {
    var endpoint: Endpoint {
        return .media
    }
    
    func toJson() -> JSON? {
        guard syncStatus != .clean, let relatedEntityID = relatedEntityID.value else {
            return nil
        }

        var byteArray = [Int]()
        if let localURL = localURL {
            do {
                let data = try Data(contentsOf: localURL).base64EncodedData()
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
        }

        let dict: [JsonKey: JSONEncodable] = [
            .qotId: localID,
            .mediaFormat: mediaFormat,
            .idOfRelatedEntity: relatedEntityID,
            .mediaEntity: mediaEntity,
            .base64Data: byteArray.toJSON()
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}
