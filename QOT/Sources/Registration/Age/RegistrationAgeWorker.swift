//
//  RegistrationAgeWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationAgeWorker: BaseSigningWorker {

    // MARK: - Properties

    lazy var title: String = {
        return titleService.localizedString(for: .OnboardingRegistrationAgeTitle)
    }()

    lazy var agePlaceholder: String = {
//        return titleService.localizedString(for: .OnboardingRegistrationAgePlaceholder)
        return ""
    }()

    lazy var descriptionText: String = {
        return R.string.localized.onboardingRegistrationAgeDescription()
    }()

    lazy var ageRestrictionText: String = {
        return titleService.localizedString(for: .OnboardingRegistrationAgeRestriction)
    }()

    lazy var nextButtonTitle: String = {
         return titleService.localizedString(for: .OnboardingRegistrationAgeNextTitle)
    }()

    // MARK: - Init

    init() {
    }
}
