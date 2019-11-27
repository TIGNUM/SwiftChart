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
        return AppTextService.get(AppTextKey.onboarding_sign_up_code_verification_section_header_title)
    }()

    lazy var description: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_code_verification_section_header_body_description)
    }()

    lazy var preCode: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_code_verification_section_body_label_code)
    }()

    lazy var disclaimerError: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_code_verification_section_disclaimer_label_disclaimer_error)
    }()

    lazy var disclaimer: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_code_verification_section_disclaimer_body_disclaimer)
    }()

    lazy var disclaimerTermsPlaceholder: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_code_verification_section_disclaimer_button_disclaimer_terms_placeholder)
    }()

    lazy var disclaimerPrivacyPlaceholder: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_code_verification_section_disclaimer_button_disclaimer_privacy_placeholder)
    }()

    lazy var codeInfo: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_code_verification_section_help_body_code_info)
    }()

    lazy var changeEmail: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_code_verification_section_help_button_change_email)
    }()

    lazy var sendAgain: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_code_verification_section_help_button_send_again)
    }()

    lazy var help: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_code_verification_section_help_button_help)
    }()

    lazy var codeError: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_code_verification_alert_code_error_body)
    }()

    lazy var resendCodeError: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_code_verification_alert_code_error_body)
    }()
}
