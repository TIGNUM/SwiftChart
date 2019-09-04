//
//  RegistrationCodeWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 10/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class RegistrationCodeWorker: BaseSigningWorker {

    // MARK: - Properties

    let email: String

    // MARK: - Init

    init(email: String,
         _ sessionService: SessionService = SessionService.main,
         _ userService: qot_dal.UserService = qot_dal.UserService.main) {
        self.email = email
        super.init(sessionService, userService)
    }

    // Texts

    lazy var title: String = {
        return titleService.localizedString(for: .OnboardingRegistrationCodeTitle)
    }()

    lazy var description: String = {
        return R.string.localized.onboardingRegistrationCodeDescription()
    }()

    lazy var preCode: String = {
        return R.string.localized.onboardingRegistrationCodePreCode()
    }()

    lazy var disclaimerError: String = {
        return R.string.localized.onboardingRegistrationCodeDisclaimerError()
    }()

    lazy var disclaimer: String = {
        return R.string.localized.onboardingRegistrationCodeDisclaimer()
    }()

    lazy var disclaimerTermsPlaceholder: String = {
        return R.string.localized.onboardingRegistrationCodeDisclaimerTermsPlaceholder()
    }()

    lazy var disclaimerPrivacyPlaceholder: String = {
        return R.string.localized.onboardingRegistrationCodeDisclaimerPrivacyPlaceholder()
    }()

    lazy var codeInfo: String = {
        return R.string.localized.onboardingRegistrationCodeCodeInfo()
    }()

    lazy var changeEmail: String = {
        return R.string.localized.onboardingRegistrationCodeChangeEmail()
    }()

    lazy var sendAgain: String = {
        return R.string.localized.onboardingRegistrationCodeSendAgain()
    }()

    lazy var help: String = {
        return R.string.localized.onboardingRegistrationCodeHelp()
    }()

    lazy var codeError: String = {
        return R.string.localized.onboardingRegistrationCodeCodeError()
    }()

    lazy var resendCodeError: String = {
        return R.string.localized.onboardingRegistrationCodeSendCodeError()
    }()
}
