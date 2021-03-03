//
//  UserProfileModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 09.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct UserProfileModel: Equatable {
    var imageURL: URL?
    var givenName: String?
    var familyName: String?
    var position: String?
    var memberSince: Date
    var company: String?
    var email: String?
    var telephone: String?
    var gender: String?
    var height: Double
    var heightUnit: String
    var weight: Double
    var weightUnit: String
    var birthday: String

    public static func == (lhs: UserProfileModel, rhs: UserProfileModel) -> Bool {
        return lhs.imageURL == rhs.imageURL &&
            lhs.givenName == rhs.givenName &&
            lhs.familyName == rhs.familyName &&
            lhs.position == rhs.position &&
            lhs.memberSince == rhs.memberSince &&
            lhs.company == rhs.company &&
            lhs.email == rhs.email &&
            lhs.telephone == rhs.telephone &&
            lhs.gender == rhs.gender &&
            lhs.height == rhs.height &&
            lhs.heightUnit == rhs.heightUnit &&
            lhs.weight == rhs.weight &&
            lhs.weightUnit == rhs.weightUnit &&
            lhs.birthday == rhs.birthday
    }
}

extension UserProfileModel {
    var name: String {
        let firstName = givenName?.capitalized ?? String.empty
        let lastName = familyName?.capitalized ?? String.empty
        return  firstName + " " + lastName
    }

    var yearOfBirth: String {
        let dateOfBrith = DateFormatter.yyyyMMdd.date(from: birthday)
        return String(dateOfBrith?.year() ?? .zero)
    }
}
