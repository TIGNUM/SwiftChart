//
//  RegistrationNamesWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 12/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class RegistrationNamesWorker: BaseSigningWorker {

    // MARK: - Properties

    lazy var title: String = {
        return AppTextService.get(.onboarding_sign_up_enter_name_section_header_title)
    }()

    lazy var firstNameTitle: String = {
        return AppTextService.get(.onboarding_sign_up_enter_name_section_body_placeholder_name)
    }()

    lazy var lastNameTitle: String = {
        return AppTextService.get(.onboarding_sign_up_enter_name_section_body_placeholder_last_name)
    }()

    lazy var mandatoryText: String  = {
        return AppTextService.get(.onboarding_sign_up_enter_name_section_body_label_mandatory)
    }()

    lazy var agePlaceholder: String = {
           return AppTextService.get(.onboarding_sign_up_age_verification_section_body_placeholder_title)
    }()

    lazy var ageRestrictionText: String = {
        return AppTextService.get(.onboarding_sign_up_age_verification_section_body_create_account_label_restriction)
    }()

    lazy var nextButtonTitle: String = {
        return AppTextService.get(.onboarding_sign_up_age_verification_section_footer_button_next)
    }()

    // MARK: - Init

    init() {
    }
}
