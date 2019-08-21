//
//  RegistrationNamesWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 12/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationNamesWorker {

    // MARK: - Properties

    lazy var title: String = {
        return R.string.localized.onboardingRegistrationNamesTitle()
    }()

    lazy var firstNameTitle: String = {
        return R.string.localized.onboardingRegistrationNamesName()
    }()

    lazy var lastNameTitle: String = {
        return R.string.localized.onboardingRegistrationNamesSurname()
    }()

    lazy var mandatoryText: String  = {
        return R.string.localized.onboardingRegistrationNamesMandatory()
    }()

    lazy var nextButtonTitle: String = {
        return R.string.localized.onboardingRegistrationNamesNextTitle()
    }()

    // MARK: - Init

    init() {
    }
}
