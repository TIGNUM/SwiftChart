//
//  PartnerSharingEmail.swift
//  QOT
//
//  Created by karmic on 07.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct PartnerSharingEmail {

    let subject: String
    let body: String

    init(json: JSON) throws {
        subject = try json.getItemValue(at: .subject)
        body = try json.getItemValue(at: .body)
    }

    static func parse(_ data: Data) throws -> PartnerSharingEmail {
        return try PartnerSharingEmail(json: try JSON(data: data))
    }
}
