//
//  MyToBeVisionIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 28.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct MyToBeVisionIntermediary: DownSyncIntermediary {

    var headline: String?
    var subHeadline: String?
    var text: String?
    var remoteProfileImageURL: String?
    var validFrom: Date
    var validTo: Date?

    init(json: JSON) throws {
        remoteProfileImageURL = try json.getString(at: JsonKey.images.rawValue, 0, JsonKey.mediaUrl.rawValue,
                                                   alongPath: [.missingKeyBecomesNil, .nullBecomesNil])
        headline = try json.getItemValue(at: .title)
        subHeadline = try json.getItemValue(at: .shortDescription)
        text = try json.getItemValue(at: .description)
        validFrom = (try json.getDate(at: .validFrom) as Date?) ?? Date()
        validTo = try json.getDate(at: .validUntil)
    }
}
