//
//  UserService.swift
//  QOT
//
//  Created by karmic on 29.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class UserService {

    private let mainRealm: Realm
    private let realmProvider: RealmProvider

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func user() -> User? {
        return mainRealm.objects(User.self).first
    }

    func updateUserGender(user: User, gender: String) {
        do {
            try mainRealm.write {
                user.gender = gender
            }
        } catch let error {
            assertionFailure("Update user, error: \(error)")
        }
    }

    func updateUserDateOfBirth(user: User, dateOfBirth: String) {
        do {
            try mainRealm.write {
                user.dateOfBirth = dateOfBirth
            }
        } catch let error {
            assertionFailure("Update user, error: \(error)")
        }
    }

    func updateUserWeight(user: User, weight: Double) {
        do {
            try mainRealm.write {
                user.weight.value = weight
            }
        } catch let error {
            assertionFailure("Update user, error: \(error)")
        }
    }

    func updateUserWeightUnit(user: User, weightUnit: String) {
        do {
            try mainRealm.write {
                user.weightUnit = weightUnit
            }
        } catch let error {
            assertionFailure("Update user, error: \(error)")
        }
    }

    func updateUserHeight(user: User, height: Double) {
        do {
            try mainRealm.write {
                user.height.value = height
            }
        } catch let error {
            assertionFailure("Update user, error: \(error)")
        }
    }

    func updateUserHeightUnit(user: User, heightUnit: String) {
        do {
            try mainRealm.write {
                user.heightUnit = heightUnit
            }
        } catch let error {
            assertionFailure("Update user, error: \(error)")
        }
    }
}
