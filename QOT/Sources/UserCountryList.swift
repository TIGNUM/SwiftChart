//
//  UserCountryList.swift
//  QOT
//
//  Created by karmic on 12.06.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct UserCountryList {

    // MARK: - Properties

    let countries: [UserCountry]

    // MARK: - Init

    init(json: JSON) throws {
        var tempCountryList = [UserCountry]()
        let resultList = try json.getArray(at: .resultList, fallback: [])
        resultList.forEach { (json) in
            do {
                try tempCountryList.append(UserCountry(json: json))
            } catch {
                log("Failed append userCountry item: \(error)", level: .error)
            }
        }
        countries = tempCountryList
    }

    static func parse(_ data: Data) throws -> UserCountryList {
        return try UserCountryList(json: try JSON(data: data))
    }
}
