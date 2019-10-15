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

    lazy var title: String = {
        return AppTextService.get(AppTextKey.login_view_title)
    }()

    lazy var emailPlaceholder: String = {
        return AppTextService.get(AppTextKey.login_view_title_your_email)
    }()

    lazy var emailInstructions: String = {
        return AppTextService.get(AppTextKey.login_view_title_email_description)
    }()

    lazy var emailError: String = {
        return AppTextService.get(AppTextKey.login_view_title_email_error)
    }()

    lazy var emailUserDoesntExist: String = {
        return AppTextService.get(AppTextKey.login_view_title_user_doesnt_exist)
    }()

    lazy var generalEMailError: String = {
        return AppTextService.get(AppTextKey.login_view_title_generic_error)
    }()

    lazy var digitDescription: String = {
        return AppTextService.get(AppTextKey.login_view_title_code_description)
    }()

    lazy var preCode: String = {
        return AppTextService.get(AppTextKey.login_view_title_pre_code)
    }()

    lazy var codeError: String = {
        return AppTextService.get(AppTextKey.login_view_title_code_error)
    }()

    lazy var buttonGetHelp: String = {
        return AppTextService.get(AppTextKey.login_view_button_gethelp)
    }()

    lazy var buttonResendCode: String = {
        return AppTextService.get(AppTextKey.login_view_button_resend_code)
    }()
}
