//
//  RegistrationAgeWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class RegistrationAgeWorker: BaseSigningWorker {

    // MARK: - Properties

    lazy var title: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_age_verification_section_header_title)
    }()

    lazy var agePlaceholder: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_age_verification_section_body_placeholder_title)
    }()

    lazy var descriptionText: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_age_verification_view_create_account_body_description)
    }()

    lazy var ageRestrictionText: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_age_verification_section_body_create_account_label_restriction)
    }()

    lazy var nextButtonTitle: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_age_verification_section_footer_button_next)
    }()

    // MARK: - Init

    init() {
    }
}
