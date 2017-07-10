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
    }
    
    func prepare(completion: @escaping (Error?) -> Void) {
        guard myToBeVision() != nil else {
            createMyToBeVision(success: { _ in
                completion(nil)
            }, failure: { (error: Error?) in
                completion(error)
            })
            return
        }
        completion(nil)
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

// MARK: - MyToBeVision

extension UserService {
    func myToBeVision() -> MyToBeVision? {
        return mainRealm.objects(MyToBeVision.self).first
    }
    
    func myToBeVisionIntermediary() -> MyToBeVisionIntermediary? {
        guard let mytoBeVision = myToBeVision() else {
            return nil
        }
        return MyToBeVisionIntermediary(
            localID: mytoBeVision.localID,
            headline: mytoBeVision.headline,
            subHeadline: mytoBeVision.subHeadline,
            text: mytoBeVision.text,
            profileImageURL: mytoBeVision.profileImageURL,
            date: mytoBeVision.date)
    }
    
    func createMyToBeVision(success: ((MyToBeVision) -> Void)?, failure: ((Error?) -> Void)?) {
        do {
            let realm = try self.realmProvider.realm()
            try realm.write {
                let myToBeVision = realm.create(MyToBeVision.self, value: MyToBeVision(), update: false)
                DispatchQueue.main.async {
                    success?(myToBeVision)
                }
            }
        } catch {
            DispatchQueue.main.async {
                failure?(error)
            }
        }
    }
    
    func updateMyToBeVision(_ myToBeVision: MyToBeVisionIntermediary, completion: ((Error?) -> Void)?) {
        DispatchQueue.global().async {
            do {
                let realm = try self.realmProvider.realm()
                try realm.write {
                    let realmObj = MyToBeVision(
                        localID: myToBeVision.localID,
                        headline: myToBeVision.headline,
                        subHeadline: myToBeVision.subHeadline,
                        text: myToBeVision.text,
                        profileImageURL: myToBeVision.profileImageURL,
                        date: myToBeVision.date)
                    realm.add(realmObj, update: true)
                    DispatchQueue.main.async {
                        completion?(nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion?(error)
                }
            }
        }
    }

}
