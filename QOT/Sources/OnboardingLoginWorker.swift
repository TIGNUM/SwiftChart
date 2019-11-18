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
        return AppTextService.get(AppTextKey.onboarding_log_in_section_header_title)
    }()

    lazy var emailPlaceholder: String = {
        return AppTextService.get(AppTextKey.onboarding_log_in_section_email_verification_placeholder_email)
    }()

    lazy var emailInstructions: String = {
        return AppTextService.get(AppTextKey.onboarding_log_in_section_email_verification_subtitle_instructions)
    }()

    lazy var emailError: String = {
        return AppTextService.get(AppTextKey.onboarding_log_in_section_email_verification_error_subtitle_invalid_username)
    }()

    lazy var emailUserDoesntExist: String = {
        return AppTextService.get(AppTextKey.onboarding_log_in_section_email_verification_error_subtitle_unknown_user)
    }()

    lazy var generalEMailError: String = {
        return AppTextService.get(AppTextKey.onboarding_log_in_section_email_verification_error_subtitle_general)
    }()

    lazy var digitDescription: String = {
        return AppTextService.get(AppTextKey.onboarding_log_in_section_code_verification_subtitle_instructions)
    }()

    lazy var preCode: String = {
        return AppTextService.get(AppTextKey.onboarding_log_in_section_code_verification_label)
    }()

    lazy var codeError: String = {
        return AppTextService.get(AppTextKey.onboarding_log_in_section_code_verification_error_subtitle_wrong_code)
    }()

    lazy var buttonGetHelp: String = {
        return AppTextService.get(AppTextKey.onboarding_log_in_section_code_verification_button_get_help)
    }()

    lazy var buttonChangeEmail: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_code_verification_section_help_button_change_email)
    }()

    lazy var buttonResendCode: String = {
        return AppTextService.get(AppTextKey.onboarding_log_in_section_code_verification_button_resend_code)
    }()

    lazy var buttonSeparator: String = {
        return "===We need to Add AppTextKey here==="//R.string.localized.onboardingLoginButtonSeparator()
    }()
}
