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

    enum FitbitState: String {
        case connected = "CONNECTED"
        case disconnected = "DISCONNECTED"
        case pending = "PENDING"

        var addSensorText: String {
            switch self {
            case .connected: return ""
            case .disconnected: return R.string.localized.meChartAddSensor()
            case .pending: return R.string.localized.meChartAddSensorPending()
            }
        }
    }

    @objc dynamic var changeStamp: String?

    @objc dynamic var gender: String = ""

    @objc dynamic var jobTitle: String?

    @objc dynamic var email: String = ""

    @objc dynamic var telephone: String?

    @objc dynamic var dateOfBirth: String?

    @objc dynamic var heightUnit: String?

    @objc dynamic var weightUnit: String?

    @objc dynamic var userImage: MediaResource? = MediaResource()

    // MARK: Data

    @objc private(set) dynamic var givenName: String = ""

    @objc private(set) dynamic var familyName: String = ""

    @objc private(set) dynamic var zipCode: String?

    @objc private(set) dynamic var city: String?

    @objc private(set) dynamic var street: String?

    @objc private(set) dynamic var streetNumber: String?

    @objc private(set) dynamic var countryID: Int = 0

    @objc private(set) dynamic var countryName: String = ""

    @objc private(set) dynamic var zoneID: Int = 0

    @objc private(set) dynamic var zoneName: String = ""

    let height = RealmOptional<Double>()

    @objc private(set) dynamic var heightUnitsJSON: String = ""

    let weight = RealmOptional<Double>()

    @objc private(set) dynamic var weightUnitsJSON: String = ""

    @objc private(set) dynamic var company: String?

    @objc private(set) dynamic var firstLevelSupportEmail: String = ""

    @objc private(set) dynamic var appUpdatePrompt: Bool = false

    @objc private(set) dynamic var memberSince: Date = Date()

    @objc dynamic var totalUsageTime: Int = 0

    @objc dynamic var timeZone: String = TimeZone.hoursFromGMT

    @objc private(set) dynamic var fitbitStateValue: String = ""
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
        userImage?.setRemoteURL(data.userImageURLString.flatMap({ URL(string: $0) }))
        height.value = data.height
        heightUnit = data.heightUnit
        heightUnitsJSON = data.heightUnitsJSON
        weight.value = data.weight
        weightUnit = data.weightUnit
        weightUnitsJSON = data.weightUnitsJSON
        company = data.company
        jobTitle = data.jobTitle
        firstLevelSupportEmail = data.firstLevelSupportEmail ?? Defaults.firstLevelSupportEmail
        appUpdatePrompt = data.appUpdatePrompt ?? false
        memberSince = data.memberSince
        totalUsageTime = data.totalUsageTime
        timeZone = TimeZone.hoursFromGMT // We never want to update the timezone based on remote timezone
        environment.dynamicBaseURL = URL(string: data.esbDomain)
        fitbitStateValue = data.fitbitState
        updateUAirshipTags(data.urbanAirshipTags + [data.email])
        AppDelegate.current.appCoordinator.setupBugLife()
        AppDelegate.current.setupSiren(services: AppCoordinator.appState.services)
    }

    private func updateUAirshipTags(_ tags: [String]) {
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
            .jobTitle: jobTitle.toJSONEncodable,
            .firstLevelSupportEmail: firstLevelSupportEmail
        ]

        let userInfo: [JsonKey: JSONEncodable] = [
            .height: height.value.toJSONEncodable,
            .heightUnit: heightUnit.toJSONEncodable,
            .weight: weight.value.toJSONEncodable,
            .weightUnit: weightUnit.toJSONEncodable
        ]

        let dict: [JsonKey: JSONEncodable] = [
            .gender: gender.uppercased(),
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
            .memberSince: memberSince,
            .totalUsageTime: QOTUsageTimer.sharedInstance.totalSeconds.toInt,
            .employment: JSON.dictionary(employment.mapKeyValues({ ($0.rawValue, $1.toJSON()) })),
            .userInfo: JSON.dictionary(userInfo.mapKeyValues({ ($0.rawValue, $1.toJSON()) })),
            .timeZone: timeZone
        ]

        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }

    static func object(remoteID: Int, store: ObjectStore, data: UserIntermediary) throws -> User? {
        return store.objects(User.self).first
    }

    var fitbitState: FitbitState {
        return FitbitState(rawValue: fitbitStateValue) ?? .disconnected
    }
}
