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
        return AppTextService.get(AppTextKey.onboarding_sign_up_email_verification_section_header_title)
    }()

    lazy var emailPlaceholder: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_email_verification_section_body_placeholder)
    }()

    lazy var nextButtonTitle: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_email_verification_section_footer_button_next)
    }()

    lazy var emailError: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_email_verification_error_enter_email_text)
    }()

    lazy var unableToRegisterError: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_email_verification_error_body_unable_to_register_error)
    }()

    lazy var generalError: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_email_verification_alert_general_error_body)
    }()

}
