//
//  UserIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 13.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct UserIntermediary: DownSyncIntermediary {

    let gender: String
    let givenName: String
    let familyName: String
    let dateOfBirth: String?
    let email: String
    let telephone: String?
    let zipCode: String?
    let city: String?
    let street: String?
    let streetNumber: String?
    let countryID: Int
    let countryName: String
    let zoneID: Int
    let zoneName: String
    let userImageURLString: String?
    let height: Double?
    let heightUnit: String?
    let heightUnitsJSON: String
    let weight: Double?
    let weightUnit: String?
    let weightUnitsJSON: String
    let company: String?
    let jobTitle: String?
    let memberSince: Date

    init(json: JSON) throws {
        self.gender = try json.getItemValue(at: .gender)
        self.givenName = try json.getItemValue(at: .firstName)
        self.familyName = try json.getItemValue(at: .lastName)
        self.dateOfBirth =  try json.getItemValue(at: .birthdate)
        self.email = try json.getItemValue(at: .email)
        self.telephone = try json.getItemValue(at: .telephone, alongPath: .NullBecomesNil)
        self.zipCode = try json.getItemValue(at: .zip, alongPath: .NullBecomesNil)
        self.city = try json.getItemValue(at: .city, alongPath: .NullBecomesNil)
        self.street = try json.getItemValue(at: .street, alongPath: .NullBecomesNil)
        self.streetNumber = try json.getItemValue(at: .streetNumber, alongPath: .NullBecomesNil)
        self.countryID = try json.getInt(at: JsonKey.country.rawValue, JsonKey.id.rawValue)
        self.countryName = try json.getString(at: JsonKey.country.rawValue, JsonKey.name.rawValue)
        self.zoneID = try json.getInt(at: JsonKey.zone.rawValue, JsonKey.id.rawValue)
        self.zoneName = try json.getString(at: JsonKey.zone.rawValue, JsonKey.name.rawValue)
        self.userImageURLString = try json.getItemValue(at: .userImageURL, alongPath: .NullBecomesNil)
        self.memberSince = try json.getDate(at: .memberSince)
        self.company = try json.getString(at: JsonKey.employment.rawValue, JsonKey.company.rawValue, alongPath: .NullBecomesNil)
        self.jobTitle = try json.getString(at: JsonKey.employment.rawValue, JsonKey.jobTitle.rawValue, alongPath: .NullBecomesNil)

        let userInfo = try json.json(at: .userInfo)
        self.height = try userInfo.getItemValue(at: .height, alongPath: .NullBecomesNil)
        self.heightUnit = try userInfo.getItemValue(at: .heightUnit, alongPath: .NullBecomesNil)
        self.heightUnitsJSON = try userInfo.serializeString(at: .heightUnits)
        self.weight = try userInfo.getItemValue(at: .weight, alongPath: .NullBecomesNil)
        self.weightUnit = try userInfo.getItemValue(at: .weightUnit, alongPath: .NullBecomesNil)
        self.weightUnitsJSON = try userInfo.serializeString(at: .weightUnits)
    }
}
