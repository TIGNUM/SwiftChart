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
        updateTimeZone()
    }

    func user() -> User? {
        return mainRealm.objects(User.self).first
    }

    func updateUserJobTitle(user: User, title: String) {
        updateUser(user: user) {
            $0.jobTitle = title
        }
    }

    func updateUserEmail(user: User, email: String) {
        updateUser(user: user) {
            $0.email = email
        }
    }

    func updateUserTelephone(user: User, telephone: String) {
        updateUser(user: user) {
            $0.telephone = telephone
        }
    }

    func updateUserGivenName(user: User, name: String) {
        updateUser(user: user) {
            $0.givenName = name
        }
    }

    func updateUserFamilyName(user: User, name: String) {
        updateUser(user: user) {
            $0.familyName = name
        }
    }

    func updateUserGender(user: User, gender: String) {
        updateUser(user: user) {
            $0.gender = gender.replacingOccurrences(of: " ", with: "_").uppercased()
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

    func updateTimeZone(completion: (() -> Void)? = nil) {
        let timeZone = TimeZone.hoursFromGMT
        if let user = user(), timeZone != user.timeZone {
            updateUser(user: user) {
                $0.timeZone = timeZone
                completion?()
            }
        }
    }

    func updateTotalUsageTime(_ time: TimeInterval) {
        if let user = user() {
            updateUser(user: user) {
                $0.totalUsageTime = time.toInt
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

// MARK: - FitbitState

extension UserService {

    var fitbitState: User.FitbitState {
        return user()?.fitbitState ?? .disconnected
    }
}

// MARK: - MyToBeVision

extension UserService {

    func myToBeVision() -> MyToBeVision? {
        return myToBeVisions().last
    }

    func myToBeVisions() -> AnyRealmCollection<MyToBeVision> {
        return AnyRealmCollection(mainRealm.objects(MyToBeVision.self))
    }

    func setMyToBeVisionReminder(_ remind: Bool) {
        do {
            let realm = try realmProvider.realm()
            try realm.write {
                AnyRealmCollection(realm.objects(MyToBeVision.self)).last?.needsToRemind = remind
            }
        } catch {
            log(error, level: .error)
        }
    }

    func saveVisionAndSync(_ new: MyToBeVisionModel.Model?, syncManager: SyncManager, completion: (() -> Void)?) {
        guard
            let old = myToBeVision(),
            let new = new, old.model != new else { return }
        updateMyToBeVision(old) {
            $0.headline = new.headLine
            $0.text = new.text
            $0.date = new.lastUpdated
            $0.setKeywords(new.workTags ?? [], for: .work)
            $0.setKeywords(new.homeTags ?? [], for: .home)
            updateVisionImage(newImageURL: new.imageURL, old: $0)
        }
        syncManager.syncMyToBeVision { (error) in
            completion?()
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

    func updateVisionImage(newImageURL: URL?, old: MyToBeVision) {
        if let imageURL = newImageURL,
            imageURL != old.profileImageResource?.url,
            imageURL.isLocalImageDirectory() {
            old.profileImageResource?.setLocalURL(imageURL,
                                                  format: .jpg,
                                                  entity: .toBeVision,
                                                  entitiyLocalID: old.localID)
        }
        if newImageURL == nil, old.profileImageResource?.url != nil {
            old.profileImageResource?.delete()
        }
    }

    func eraseToBeVision() {
        guard let toBeVision = myToBeVision() else {
            return
        }
        do {
            try mainRealm.write {
                mainRealm.delete(toBeVision)
            }
        } catch {
            assertionFailure("Failed to delete toBeVision with error: \(error)")
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
