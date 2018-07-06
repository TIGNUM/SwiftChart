//
//  UserSigning.swift
//  QOT
//
//  Created by karmic on 06.07.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct UserSigning {

    // MARK: - Properties

    var email: String?
    var gender: String?
    var firstName: String?
    var lastName: String?
    var birthdate: String?
    var country: UserCountry?
    var password: String?
    var verificationCode: String?

    // MARK: - Init

    init(json: JSON) throws {
        email = try json.getItemValue(at: .email, alongPath: .nullBecomesNil)
        gender = try json.getItemValue(at: .gender, alongPath: .nullBecomesNil)
        firstName = try json.getItemValue(at: .firstName, alongPath: .nullBecomesNil)
        lastName = try json.getItemValue(at: .lastName, alongPath: .nullBecomesNil)
        birthdate = try json.getItemValue(at: .birthdate, alongPath: .nullBecomesNil)
        let countryJson = try json.json(at: .country)
        country = try UserCountry(json: countryJson)
    }

    init(email: String, code: String?) {
        self.email = email
        self.verificationCode = code
    }

    static func parse(_ data: Data) throws -> UserSigning {
        return try UserSigning(json: try JSON(data: data))
    }

    func toJson() -> JSON? {
        guard
            let email = email,
            let gender = gender,
            let firstName = firstName,
            let lastName = lastName,
            let birthdate = birthdate,
            let country = country,
            let password = password,
            let verificationCode = verificationCode else { return nil }
        let userCountryDict: [JsonKey: JSONEncodable] = [.id: country.id]
        let countryJson = JSON.dictionary(userCountryDict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
        let dict: [JsonKey: JSONEncodable] = [.email: email,
                                              .gender: gender,
                                              .firstName: firstName,
                                              .lastName: lastName,
                                              .birthdate: birthdate,
                                              .country: countryJson,
                                              .password: password,
                                              .code: verificationCode]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }

}
