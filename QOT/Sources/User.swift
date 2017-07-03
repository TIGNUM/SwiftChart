//
//  User.swift
//  QOT
//
//  Created by Sam Wyndham on 13.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class User: Object {

    // MARK: SyncableRealmObject

    dynamic var remoteID: Int = 0

    dynamic var _syncStatus: Int8 = 0

    dynamic var createdAt: Date = Date()

    dynamic var modifiedAt: Date = Date()

    dynamic var gender: String = ""

    dynamic var dateOfBirth: String?

    dynamic var heightUnit: String?

    dynamic var weightUnit: String?

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
}

extension User: DownSyncable {
    
    static func make(remoteID: Int, createdAt: Date) -> User {
        let user = User()
        user.remoteID = remoteID
        user.createdAt = createdAt
        return user
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
    }
}
