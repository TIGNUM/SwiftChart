//
//  UserProfileManager.swift
//  QOT
//
//  Created by Ashish Maheshwari on 09.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class UserProfileManager {

    private let services: Services
    private let syncManger: SyncManager
    private let user: User?

    init(_ services: Services, _ syncManger: SyncManager) {
        self.services = services
        self.syncManger = syncManger
        self.user = services.userService.user()
    }

    func profile() -> UserProfileModel? {
        return UserProfileModel(imageURL: user?.userImage?.url,
                                    givenName: user?.givenName,
                                    familyName: user?.familyName,
                                    position: user?.jobTitle,
                                    memberSince: user?.memberSince ?? Date(),
                                    company: user?.company,
                                    email: user?.email,
                                    telephone: user?.telephone,
                                    gender: user?.gender,
                                    height: user?.height.value ?? 150,
                                    heightUnit: user?.heightUnit ?? "",
                                    weight: user?.weight.value ?? 60,
                                    weightUnit: user?.weightUnit ?? "",
                                    birthday: user?.dateOfBirth ?? "")
    }

    func upSyncUser() {
        syncManger.upSyncUser { error in
            if let error = error {
                log(error.localizedDescription, level: .error)
            }
        }
    }

    func updateProfileTelephone(_ new: UserProfileModel) {
        guard let user = user, let old = profile(), old != new else { return }
        let numberLength = new.telephone?.count ?? 0
        if old.telephone != new.telephone &&
            (numberLength == 0 || (numberLength > 0 && new.telephone?.isPhoneNumber == true)) {
            services.userService.updateUserTelephone(user: user, telephone: new.telephone ?? "")
            upSyncUser()
        }
    }

    func updateProfileBirthday(_ new: UserProfileModel) {
        guard let user = user, let old = profile(), old != new else { return }
        if old.birthday != new.birthday {
            services.userService.updateUserDateOfBirth(user: user, dateOfBirth: new.birthday)
            upSyncUser()
        }
    }

    func updateProfileGivenName(_ new: UserProfileModel) {
        guard let user = user, let old = profile(), old != new else { return }
        if old.givenName?.caseInsensitiveCompare(new.givenName ?? "") != .orderedSame {
            services.userService.updateUserGivenName(user: user, name: new.givenName ?? "")
            upSyncUser()
        }
    }

    func updateProfileFamilyName(_ new: UserProfileModel) {
        guard let user = user, let old = profile(), old != new else { return }
        if old.familyName?.caseInsensitiveCompare(new.familyName ?? "") != .orderedSame {
            services.userService.updateUserFamilyName(user: user, name: new.familyName ?? "")
            upSyncUser()
        }
    }

    func updateProfileGender(_ new: UserProfileModel) {
        guard let user = user, let old = profile(), old != new else { return }
        if old.gender?.caseInsensitiveCompare(new.gender ?? "") != .orderedSame {
            services.userService.updateUserGender(user: user, gender: new.gender ?? "")
            upSyncUser()
        }
    }

    func updateJobTitle(_ new: UserProfileModel) {
        guard let user = user, let old = profile(), let newPosition = new.position, old != new else { return }
        if old.position != newPosition {
            services.userService.updateUserJobTitle(user: user, title: newPosition)
            upSyncUser()
        }
    }

    func updateHeight(_ new: UserProfileModel) {
        guard let old = profile(), old != new else { return }
        if old.height != new.height || old.heightUnit != new.heightUnit {
            updateHeight(meters: new.height, unit: new.heightUnit)
            upSyncUser()
        }
    }

    func updateWeight(_ new: UserProfileModel) {
        guard let old = profile(), old != new else { return }

        if old.weight != new.weight || old.weightUnit != new.weightUnit {
            updateWeight(weight: new.weight, unit: new.weightUnit)
            upSyncUser()
        }
    }

    func updateSettingsProfileImage(_ new: URL?) {
        let old = profile()?.imageURL
        guard let user = user, old != new else { return }
        services.userService.updateUser(user: user) { (user) in
            if let new = new, new.isLocalImageDirectory() {
                user.userImage?.setLocalURL(new, format: .jpg, entity: .user, entitiyLocalID: user.localID)
            } else {
                user.userImage?.delete()
            }
            upSyncUser()
        }
    }

    func saveImage(_ image: UIImage) throws -> URL {
        return try image.save(withName: UUID().uuidString)
    }
}

// MARK: - Private

private extension UserProfileManager {

    func updateWeight(weight: Double, unit: String) {
        guard let user = user else { return }

        let convertedWeight: Double
        if unit == "kg" {
            convertedWeight = weight
        } else if unit == "lbs" {
            let kilograms = Measurement(value: weight, unit: UnitMass.kilograms)
            let pounds = kilograms.converted(to: .pounds)
            convertedWeight = pounds.value
        } else {
            fatalError("Invalid unit")
        }
        services.userService.updateUserWeight(user: user, weight: convertedWeight)
        services.userService.updateUserWeightUnit(user: user, weightUnit: unit)
    }

    func updateHeight(meters: Double, unit: String) {
        guard let user = user else { return }

        let meters = Measurement(value: meters, unit: UnitLength.meters)
        let convertedHeight: Double
        if unit == "cm" {
            let centimeters = meters.converted(to: .centimeters)
            convertedHeight = centimeters.value
        } else if unit == "ft" {
            let feet = meters.converted(to: .feet)
            convertedHeight = feet.value
        } else {
            fatalError("Invalid unit")
        }
        services.userService.updateUserHeight(user: user, height: convertedHeight)
        services.userService.updateUserHeightUnit(user: user, heightUnit: unit)
    }
}
