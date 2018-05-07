//
//  ProfileSettingsModel.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 25/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

struct ProfileSettingsModel: Equatable {

    var imageURL: URL?
    var givenName: String?
    var familyName: String?
    var position: String?
    var memberSince: Int
    var company: String?
    var email: String?
    var telephone: String?
    var gender: String?
    var height: Double
    var heightUnit: String
    var weight: Double
    var weightUnit: String
    var birthday: String

    public static func == (lhs: ProfileSettingsModel, rhs: ProfileSettingsModel) -> Bool {
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
