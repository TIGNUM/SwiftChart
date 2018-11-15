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

    let appUpdatePrompt: Bool?
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
    let height: Double?
    let heightUnit: String?
    let heightUnitsJSON: String
    let weight: Double?
    let weightUnit: String?
    let weightUnitsJSON: String
    let company: String?
    let jobTitle: String?
    let firstLevelSupportEmail: String?
    let memberSince: Date
    let totalUsageTime: Int
    let urbanAirshipTags: [String]
    let timeZone: String?
    let esbDomain: String
    let fitbitState: String
    var profileImages: [MediaResourceIntermediary] = []

    init(json: JSON) throws {
        self.gender = try json.getItemValue(at: .gender)
        self.givenName = try json.getItemValue(at: .firstName)
        self.familyName = try json.getItemValue(at: .lastName)
        self.dateOfBirth =  try json.getItemValue(at: .birthdate)
        self.email = try json.getItemValue(at: .email)
        self.telephone = try json.getItemValue(at: .telephone, alongPath: .nullBecomesNil)
        self.zipCode = try json.getItemValue(at: .zip, alongPath: .nullBecomesNil)
        self.city = try json.getItemValue(at: .city, alongPath: .nullBecomesNil)
        self.street = try json.getItemValue(at: .street, alongPath: .nullBecomesNil)
        self.streetNumber = try json.getItemValue(at: .streetNumber, alongPath: .nullBecomesNil)
        self.countryID = try json.getInt(at: JsonKey.country.rawValue, JsonKey.id.rawValue)
        self.countryName = try json.getString(at: JsonKey.country.rawValue, JsonKey.name.rawValue)
        self.zoneID = try json.getInt(at: JsonKey.zone.rawValue, JsonKey.id.rawValue)
        self.zoneName = try json.getString(at: JsonKey.zone.rawValue, JsonKey.name.rawValue)

        let images = try json.getArray(at: JsonKey.images.rawValue)
        for mediaResource in images {
            profileImages.append(try MediaResourceIntermediary(json: mediaResource))
        }
        if profileImages.count == 0 {
            profileImages.append(MediaResourceIntermediary.intermediary(for: .user))
        }

        self.memberSince = try json.getDate(at: .memberSince)
        self.company = try json.getString(at: JsonKey.employment.rawValue,
                                          JsonKey.company.rawValue,
                                          alongPath: .nullBecomesNil)
        self.firstLevelSupportEmail = try json.getString(at: JsonKey.employment.rawValue,
                                                         JsonKey.firstLevelSupportEmail.rawValue,
                                                         alongPath: .nullBecomesNil)
        self.jobTitle = try json.getString(at: JsonKey.employment.rawValue,
                                           JsonKey.jobTitle.rawValue,
                                           alongPath: .nullBecomesNil)
        self.appUpdatePrompt = try json.getBool(at: JsonKey.employment.rawValue,
                                                JsonKey.appUpdatePrompt.rawValue,
                                                alongPath: .nullBecomesNil)
        self.urbanAirshipTags = try json.getArray(at: .urbanAirshipTags, fallback: [])
        self.timeZone = try json.getItemValue(at: .timeZone)
        self.totalUsageTime = try json.getItemValue(at: .totalUsageTime)
        self.esbDomain = try json.getItemValue(at: .esbDomain)
        self.fitbitState = try json.getItemValue(at: .fitbitState)

        let userInfo = try json.json(at: .userInfo)
        self.height = try userInfo.getItemValue(at: .height, alongPath: .nullBecomesNil)
        self.heightUnit = try userInfo.getItemValue(at: .heightUnit, alongPath: .nullBecomesNil)
        self.heightUnitsJSON = try userInfo.serializeString(at: .heightUnits)
        self.weight = try userInfo.getItemValue(at: .weight, alongPath: .nullBecomesNil)
        self.weightUnit = try userInfo.getItemValue(at: .weightUnit, alongPath: .nullBecomesNil)
        self.weightUnitsJSON = try userInfo.serializeString(at: .weightUnits)
    }
}
