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
        return AppTextService.get(AppTextKey.onboarding_sign_up_enter_name_section_header_title)
    }()

    lazy var firstNameTitle: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_enter_name_section_body_placeholder_name)
    }()

    lazy var lastNameTitle: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_enter_name_section_body_placeholder_last_name)
    }()

    lazy var mandatoryText: String  = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_enter_name_section_body_label_mandatory)
    }()

    lazy var nextButtonTitle: String = {
        return AppTextService.get(AppTextKey.onboarding_sign_up_enter_name_section_footer_button_next)
    }()

    // MARK: - Init

    init() {
    }
}
