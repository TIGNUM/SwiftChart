//
//  RegistrationAgeWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationAgeWorker {

    // MARK: - Properties

    lazy var title: String = {
        return R.string.localized.onboardingRegistrationAgeTitle()
    }()

    lazy var descriptionText: String = {
        return R.string.localized.onboardingRegistrationAgeDescription()
    }()

    lazy var ageRestrictionText: String = {
        return R.string.localized.onboardingRegistrationAgeRestriction()
    }()

    lazy var nextButtonTitle: String = {
        return R.string.localized.onboardingRegistrationAgeNextTitle()
    }()

    // MARK: - Init

    init() {
    }
}
