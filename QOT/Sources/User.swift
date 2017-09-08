//
//  User.swift
//  QOT
//
//  Created by Sam Wyndham on 13.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import AirshipKit
import Freddy

final class User: SyncableObject {

    dynamic var changeStamp: String? = UUID().uuidString

    dynamic var gender: String = ""

    dynamic var dateOfBirth: String?

    dynamic var heightUnit: String?

    dynamic var weightUnit: String?

    dynamic var urbanAirshipDeviceToken: String?

    // MARK: Data

    fileprivate(set) dynamic var givenName: String = ""

    fileprivate(set) dynamic var familyName: String = ""

    fileprivate(set) dynamic var email: String = ""

    fileprivate(set) dynamic var telephone: String?

    fileprivate(set) dynamic var zipCode: String?

    fileprivate(set) dynamic var city: String?

    fileprivate(set) dynamic var street: String?

    fileprivate(set) dynamic var streetNumber: String?

    fileprivate(set) dynamic var countryID: Int = 0

    fileprivate(set) dynamic var countryName: String = ""

    fileprivate(set) dynamic var zoneID: Int = 0

    fileprivate(set) dynamic var zoneName: String = ""

    fileprivate(set) dynamic var userImageURLString: String?

    let height = RealmOptional<Double>()

    fileprivate(set) dynamic var heightUnitsJSON: String = ""

    let weight = RealmOptional<Double>()

    fileprivate(set) dynamic var weightUnitsJSON: String = ""

    fileprivate(set) dynamic var company: String?

    fileprivate(set) dynamic var jobTitle: String?

    fileprivate(set) dynamic var memberSince: Date = Date()

    dynamic var timeZone: String = TimeZone.currentName
}

extension User: TwoWaySyncableUniqueObject {

    static var endpoint: Endpoint {
        return .user
    }

    func setData(_ data: UserIntermediary, objectStore: ObjectStore) throws {
        gender = data.gender
        givenName = data.givenName
        familyName = data.familyName
        dateOfBirth = data.dateOfBirth
        email = data.email
        telephone = data.telephone
        zipCode = data.zipCode
        city = data.city
        street = data.street
        streetNumber = data.streetNumber
        countryID = data.countryID
        countryName = data.countryName
        zoneID = data.zoneID
        zoneName = data.zoneName
        userImageURLString = data.userImageURLString
        height.value = data.height
        heightUnit = data.heightUnit
        heightUnitsJSON = data.heightUnitsJSON
        weight.value = data.weight
        weightUnit = data.weightUnit
        weightUnitsJSON = data.weightUnitsJSON
        company = data.company
        jobTitle = data.jobTitle
        memberSince = data.memberSince
        timeZone = data.timeZone ?? TimeZone.currentName
        updateUAirship(urbanAirshipTags: data.urbanAirshipTags)
    }

    private func updateUAirship(urbanAirshipTags: [String]) {
        var tags = urbanAirshipTags
        tags.append(email)
        urbanAirshipDeviceToken = UAirship.push().deviceToken
        UAirship.push().removeTags(UAirship.push().tags)
        UAirship.push().addTags(tags)
        UAirship.push().updateRegistration()
    }

    func toJson() -> JSON? {
        guard syncStatus != .clean else { return nil }

        let country: [JsonKey: JSONEncodable] = [
            .id: countryID,
            .name: countryName
        ]

        let zone: [JsonKey: JSONEncodable] = [
            .id: zoneID,
            .name: zoneName
        ]

        let employment: [JsonKey: JSONEncodable] = [
            .company: company.toJSONEncodable,
            .jobTitle: jobTitle.toJSONEncodable
        ]

        let userInfo: [JsonKey: JSONEncodable] = [
            .height: height.value.toJSONEncodable,
            .heightUnit: heightUnit.toJSONEncodable,
            .weight: weight.value.toJSONEncodable,
            .weightUnit: weightUnit.toJSONEncodable
        ]

        #if DEBUG
            let environment = "DEVELOPMENT"
        #else
            let environment = "PRODUCTION"
        #endif

        let dict: [JsonKey: JSONEncodable] = [
            .gender: gender,
            .firstName: givenName,
            .lastName: familyName,
            .birthdate: dateOfBirth.toJSONEncodable,
            .email: email,
            .telephone: telephone.toJSONEncodable,
            .zip: zipCode.toJSONEncodable,
            .city: city.toJSONEncodable,
            .street: street.toJSONEncodable,
            .streetNumber: streetNumber.toJSONEncodable,
            .country: JSON.dictionary(country.mapKeyValues({ ($0.rawValue, $1.toJSON()) })),
            .zone: JSON.dictionary(zone.mapKeyValues({ ($0.rawValue, $1.toJSON()) })),
            .userImageURL: userImageURLString.toJSONEncodable,
            .memberSince: memberSince,
            .employment: JSON.dictionary(employment.mapKeyValues({ ($0.rawValue, $1.toJSON()) })),
            .userInfo: JSON.dictionary(userInfo.mapKeyValues({ ($0.rawValue, $1.toJSON()) })),
            .urbanAirshipDeviceToken: urbanAirshipDeviceToken.toJSONEncodable,
            .notificationEnvironmentType: environment
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }

    static func object(remoteID: Int, store: ObjectStore) throws -> User? {
        return store.objects(User.self).first
    }
}
