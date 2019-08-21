//
//  OnboardingLoginWorker.swift
//  QOT
//
//  Created by karmic on 29.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class OnboardingLoginWorker: BaseSigningWorker {

    // MARK: - Properties

    // MARK: - Init

    init() {
        super.init()
    }

    // MARK: Texts

    lazy var emailInstructions: String = {
        return R.string.localized.onboardingLoginEmailDescription()
    }()

    lazy var emailError: String = {
        return R.string.localized.onboardingLoginEmailError()
    }()

    lazy var emailUserDoesntExist: String = {
        return R.string.localized.onboardingLoginEmailUserDoesntExistError()
    }()

    lazy var generalEMailError: String = {
        return R.string.localized.onboardingLoginEmailGenericError()
    }()

    lazy var digitDescription: String = {
        return R.string.localized.onboardingLoginCodeDescription()
    }()

    lazy var codeError: String = {
        return R.string.localized.onboardingLoginCodeError()
    }()

    lazy var buttonGetHelp: String = {
        return R.string.localized.onboardingLoginButtonGetHelp()
    }()

    lazy var buttonResendCode: String = {
        return R.string.localized.onboardingLoginButtonResendCode()
    }()
}
