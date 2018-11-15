//
//  MediaResourceIntermediary.swift
//  QOT
//
//  Created by Sanggeon Park on 14.11.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import Freddy

enum MediaEntryType: String {
    case toBeVision = "TO_BE_VISION"
    case user = "PROFILE_IMAGE"

    var mediaEntityType: MediaResource.Entity {
        switch self {
        case .toBeVision:
            return MediaResource.Entity.toBeVision
        case .user:
            return MediaResource.Entity.user
        }
    }
}
struct MediaResourceIntermediary {
    var remoteID: Int?
    var sortOrder: Int?
    var name: String?
    var mediaUrl: String?
    var thumbnailUrl: String?
    var mediaFormat: String?
    var idOfRelatedEntity: Int?
    var entryType: String?
    var syncStatus: Int?
    init(json: JSON) throws {
        remoteID = try json.getInt(at: JsonKey.id.rawValue, alongPath: [.missingKeyBecomesNil, .nullBecomesNil])
        sortOrder = try json.getInt(at: JsonKey.sortOrder.rawValue, alongPath: [.missingKeyBecomesNil, .nullBecomesNil])
        name = try json.getString(at: JsonKey.name.rawValue, alongPath: [.missingKeyBecomesNil, .nullBecomesNil])
        mediaUrl = try json.getString(at: JsonKey.mediaUrl.rawValue, alongPath: [.missingKeyBecomesNil, .nullBecomesNil])
        thumbnailUrl = try json.getString(at: JsonKey.thumbnail.rawValue, alongPath: [.missingKeyBecomesNil, .nullBecomesNil])
        mediaFormat = try json.getString(at: JsonKey.mediaFormat.rawValue, alongPath: [.missingKeyBecomesNil, .nullBecomesNil])
        entryType = try json.getString(at: JsonKey.entryType.rawValue, alongPath: [.missingKeyBecomesNil, .nullBecomesNil])
        syncStatus = try json.getInt(at: JsonKey.syncStatus.rawValue, alongPath: [.missingKeyBecomesNil, .nullBecomesNil])
        idOfRelatedEntity = try json.getInt(at: JsonKey.idOfRelatedEntity.rawValue, alongPath: [.missingKeyBecomesNil, .nullBecomesNil])
    }

    init() {
        // default
    }

    static func intermediary(for entry: MediaEntryType) -> MediaResourceIntermediary {
        var data = MediaResourceIntermediary()
        data.entryType = entry.rawValue
        data.syncStatus = UpSyncStatus.clean.rawValue
        return data
    }
}
