//
//  PartnerIntermediary.swift
//  QOT
//
//  Created by Lee Arromba on 03/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Freddy

struct PartnerIntermediary {

    var remoteProfileImageURL: String?
    var name: String
    var surname: String
    var relationship: String?
    var email: String
}

extension PartnerIntermediary: DownSyncIntermediary {

    init(json: JSON) throws {
        remoteProfileImageURL = try json.getString(at: JsonKey.images.rawValue, 0, JsonKey.mediaURL.rawValue,
                                                   alongPath: [.MissingKeyBecomesNil, .NullBecomesNil])
        name = try json.getItemValue(at: .firstName, fallback: "")
        surname = try json.getItemValue(at: .lastName, fallback: "")
        relationship = try json.getItemValue(at: .relationship)
        email = try json.getItemValue(at: .email, fallback: "")
    }
}
