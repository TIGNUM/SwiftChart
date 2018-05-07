//
//  ProfileSettingsWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 23/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class ProfileSettingsWorker {

    private let services: Services
    private let syncManger: SyncManager
    private let user: User?

    init(services: Services, syncManger: SyncManager) {
        self.services = services
        self.syncManger = syncManger
        self.user = services.userService.user()
    }

    func profile() -> ProfileSettingsModel? {
        let model = ProfileSettingsModel(imageURL: user?.userImage?.remoteURL ?? user?.userImage?.localURL,
                                                 givenName: user?.givenName,
                                                 familyName: user?.familyName,
                                                 position: user?.jobTitle,
                                                 memberSince: user?.totalUsageTime ?? 0,
                                                 company: user?.company,
                                                 email: user?.email,
                                                 telephone: user?.telephone,
                                                 gender: user?.gender,
                                                 height: user?.height.value ?? 150,
                                                 heightUnit: user?.heightUnit ?? "",
                                                 weight: user?.weight.value ?? 60,
                                                 weightUnit: user?.weightUnit ?? "",
                                                 birthday: user?.dateOfBirth ?? "")
        return model
    }

    func updateSettingsProfile(_ new: ProfileSettingsModel) {
        guard
            let user = user,
            let old = profile(),
            old != new else { return }

        if old.imageURL != new.imageURL {
            guard let imageURL = new.imageURL else { return }
            services.userService.updateUser(user: user) { (user) in
                user.userImage?.setLocalURL(imageURL, format: .jpg, entity: .user, entitiyLocalID: user.localID)
            }
        } else if old.gender != new.gender {
            services.userService.updateUserGender(user: user, gender: new.gender ?? "")
        } else if old.position != new.position {
            services.userService.updateUserJobTitle(user: user, title: new.position ?? "")
        } else if old.telephone != new.telephone {
            services.userService.updateUserTelephone(user: user, telephone: new.telephone ?? "")
        } else if old.weight != new.weight  || old.weightUnit != new.weightUnit {
            updateWeight(weight: new.weight, unit: new.weightUnit)
        } else if old.height != new.height || old.heightUnit != new.heightUnit {
            updateHeight(meters: new.height, unit: new.heightUnit)
        } else if old.birthday != new.birthday {
            services.userService.updateUserDateOfBirth(user: user, dateOfBirth: new.birthday)
        }

        syncManger.syncAll(shouldDownload: false)
    }

    func saveImage(_ image: UIImage) throws -> URL {
        return try image.save(withName: UUID().uuidString)
    }
}

// MARK: - Private

private extension ProfileSettingsWorker {

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
