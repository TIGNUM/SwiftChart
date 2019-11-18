//
//  RegistrationEmailWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class RegistrationEmailWorker: BaseSigningWorker {

    // MARK: - Properties
    lazy var title: String = {
        return titleService.localizedString(for: .OnboardingRegistrationEmailTitle)
    }()

    lazy var emailPlaceholder: String = {
        return R.string.localized.onboardingRegistrationEmailPlaceholder()
    }()

    lazy var nextButtonTitle: String = {
        return R.string.localized.onboardingRegistrationEmailButtonNext()
    }()

    lazy var emailError: String = {
        return R.string.localized.onboardingRegistrationEmailError()
    }()

    lazy var unableToRegisterError: String = {
        return R.string.localized.onboardingRegistrationEmailErrorUnableToRegister()
    }()

    lazy var generalError: String = {
        return R.string.localized.onboardingErrorGeneral()
    }()

}
