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

    fileprivate let mainRealm: Realm
    fileprivate let realmProvider: RealmProvider

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider

        updateTimeZone()
    }
    
    func prepare() throws {
        guard myToBeVision() != nil else {
            _ = try createMyToBeVision()
            return
        }
    }

    func user() -> User? {
        return mainRealm.objects(User.self).first
    }
   
    func updateUserGender(user: User, gender: String) {
        updateUser(user: user) {
            $0.gender = gender
        }
    }

    func updateUserDateOfBirth(user: User, dateOfBirth: String) {
        updateUser(user: user) {
            $0.dateOfBirth = dateOfBirth
        }
    }

    func updateUserWeight(user: User, weight: Double) {
        updateUser(user: user) {
            $0.weight.value = weight
        }
    }

    func updateUserWeightUnit(user: User, weightUnit: String) {
        updateUser(user: user) {
            $0.weightUnit = weightUnit
        }
    }

    func updateUserHeight(user: User, height: Double) {
        updateUser(user: user) {
            $0.height.value = height
        }
    }

    func updateUserHeightUnit(user: User, heightUnit: String) {
        updateUser(user: user) {
            $0.heightUnit = heightUnit
        }
    }

    func updateTimeZone() {
        let timeZone = TimeZone.currentName
        if let user = user(), timeZone != user.timeZone {
            updateUser(user: user) {
                $0.timeZone = timeZone
            }
        }
    }

    func updateUser(user: User, block: (User) -> Void) {
        do {
            try mainRealm.write {
                block(user)
                user.didUpdate()
            }
        } catch let error {
            assertionFailure("Update user, error: \(error)")
        }
    }
}

// MARK: - MyToBeVision

extension UserService {
    func myToBeVision() -> MyToBeVision? {
        return mainRealm.objects(MyToBeVision.self).first
    }

    func createMyToBeVision() throws -> MyToBeVision {
        let myToBeVision = MyToBeVision()
        myToBeVision.profileImageResource = MediaResource(
            localURLString: nil,
            remoteURLString: nil,
            relatedEntityID: myToBeVision.remoteID.value,
            mediaFormat: "JPG",
            mediaEntity: "TOBEVISION"
        )
        try mainRealm.write {
            mainRealm.add(myToBeVision)
        }
        return myToBeVision
    }
    
    func updateProfileImageResource(myToBeVision: MyToBeVision, resource: MediaResource) {
        updateMyToBeVision(myToBeVision) {
            $0.profileImageResource = resource
        }
    }
    
    func updateHeadline(myToBeVision: MyToBeVision, headline: String?) {
        updateMyToBeVision(myToBeVision) {
            $0.headline = headline
        }
    }
    
    func updateText(myToBeVision: MyToBeVision, text: String?) {
        updateMyToBeVision(myToBeVision) {
            $0.text = text
        }
    }
    
    func updateMyToBeVision(_ myToBeVision: MyToBeVision, block: (MyToBeVision) -> Void) {
        do {
            try mainRealm.write {
                block(myToBeVision)
                myToBeVision.didUpdate()
            }
        } catch let error {
            assertionFailure("Update \(MyToBeVision.self), error: \(error)")
        }
    }
}

// MARK: User Choice

extension UserService {

    func userChoices() -> AnyRealmCollection<UserChoice> {
        return AnyRealmCollection(mainRealm.objects(UserChoice.self))
    }
    
    func createUserChoice(contentCategoryID: Int, contentCollectionID: Int, startDate: Date, endDate: Date) throws -> UserChoice {
        let choice = UserChoice(contentCategoryID: contentCategoryID,
                                contentCollectionID: contentCollectionID,
                                startDate: startDate,
                                endDate: endDate)
        try mainRealm.write {
            mainRealm.add(choice)
        }
        return choice
    }
}
