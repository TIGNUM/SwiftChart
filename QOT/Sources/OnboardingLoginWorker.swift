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
        return AppTextService.get(AppTextKey.login_view_your_email_title)
    }()

    lazy var emailInstructions: String = {
        return AppTextService.get(AppTextKey.login_view_email_description_title)
    }()

    lazy var emailError: String = {
        return AppTextService.get(AppTextKey.login_view_email_error_title)
    }()

    lazy var emailUserDoesntExist: String = {
        return AppTextService.get(AppTextKey.login_view_user_doesnt_exist_title)
    }()

    lazy var generalEMailError: String = {
        return AppTextService.get(AppTextKey.login_view_generic_error_title)
    }()

    lazy var digitDescription: String = {
        return AppTextService.get(AppTextKey.login_view_code_description_title)
    }()

    lazy var preCode: String = {
        return AppTextService.get(AppTextKey.login_view_pre_code_title)
    }()

    lazy var codeError: String = {
        return AppTextService.get(AppTextKey.login_view_code_error_title)
    }()

    lazy var buttonGetHelp: String = {
        return AppTextService.get(AppTextKey.login_view_button_gethelp)
    }()

    lazy var buttonResendCode: String = {
        return AppTextService.get(AppTextKey.login_view_button_resend_code)
    }()
}
