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
        let model = ProfileSettingsModel(imageURL: user?.userImage?.localURL ?? user?.userImage?.remoteURL,
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

    func updateProfileTelephone(_ new: ProfileSettingsModel) {
        guard let user = user, let old = profile(), old != new else { return }

        if old.telephone != new.telephone && new.telephone?.isPhoneNumber == true {
            services.userService.updateUserTelephone(user: user, telephone: new.telephone ?? "")
            syncManger.upSyncUser(completion: {error in
                log(error?.localizedDescription ?? String(describing: error), level: .error)
            })
        }
    }

    func updateProfileBirthday(_ new: ProfileSettingsModel) {
        guard let user = user, let old = profile(), old != new else { return }

        if old.birthday != new.birthday {
            services.userService.updateUserDateOfBirth(user: user, dateOfBirth: new.birthday)
            syncManger.upSyncUser(completion: {error in
                log(error?.localizedDescription ?? String(describing: error), level: .error)
            })
        }
    }

    func updateProfileGender(_ new: ProfileSettingsModel) {
        guard let user = user, let old = profile(), old != new else { return }

        if old.gender?.caseInsensitiveCompare(new.gender ?? "") != .orderedSame {
            services.userService.updateUserGender(user: user, gender: new.gender ?? "")
            syncManger.upSyncUser(completion: {error in
                log(error?.localizedDescription ?? String(describing: error), level: .error)
            })
        }
    }

    func updateJobTitle(_ new: ProfileSettingsModel) {
        guard let user = user, let old = profile(), let newPosition = new.position, old != new else { return }
        if old.position != newPosition {
            services.userService.updateUserJobTitle(user: user, title: newPosition)
            syncManger.upSyncUser(completion: { error in
                log(error?.localizedDescription ?? String(describing: error), level: .error)
            })
        }
    }

	func updateHeight(_ new: ProfileSettingsModel) {
		guard let old = profile(), old != new else { return }

		if old.height != new.height || old.heightUnit != new.heightUnit {
			updateHeight(meters: new.height, unit: new.heightUnit)
            syncManger.upSyncUser(completion: {error in
                log(error?.localizedDescription ?? String(describing: error), level: .error)
            })
		}
    }

    func updateWeight(_ new: ProfileSettingsModel) {
        guard let old = profile(), old != new else { return }

        if old.weight != new.weight  || old.weightUnit != new.weightUnit {
            updateWeight(weight: new.weight, unit: new.weightUnit)
            syncManger.upSyncUser(completion: {error in
                log(error?.localizedDescription ?? String(describing: error), level: .error)
            })
        }
    }

    func updateSettingsProfileImage(_ new: URL) {
        let old = profile()?.imageURL
        guard let user = user, old == nil || old != new else { return }

        let localPathComponents = new.baseURL?.pathComponents ?? []
        let expectedPathComponents = URL.imageDirectory.pathComponents

        if localPathComponents.elementsEqual(expectedPathComponents) {
            services.userService.updateUser(user: user) { (user) in
                user.userImage?.setLocalURL(new, format: .jpg, entity: .user, entitiyLocalID: user.localID)
                syncManger.upSyncUser(completion: {error in
                    log(error?.localizedDescription ?? String(describing: error), level: .error)
                })
            }
        }
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
