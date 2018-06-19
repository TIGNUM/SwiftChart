//
//  UserCountry.swift
//  QOT
//
//  Created by karmic on 12.06.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct UserCountry {

    // MARK: - Properties

    let id: Int
    let name: String
    let iso2LetterCode: String

    // MARK: - Init

    init(json: JSON) throws {
        id = try json.getItemValue(at: .id)
        name = try json.getItemValue(at: .name)
        iso2LetterCode = try json.getItemValue(at: .iso2LetterCode)
    }

    static func parse(_ data: Data) throws -> UserCountry {
        return try UserCountry(json: try JSON(data: data))
    }
}
