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
        return AppTextService.get(AppTextKey.create_account_email_verification_view_title)
    }()

    lazy var emailPlaceholder: String = {
        return AppTextService.get(AppTextKey.create_account_email_verification_view_title_email_placeholder)
    }()

    lazy var nextButtonTitle: String = {
        return AppTextService.get(AppTextKey.create_account_email_verification_view_button_next)
    }()

    lazy var emailError: String = {
        return AppTextService.get(AppTextKey.create_account_email_verification_view_email_error_title)
    }()

    lazy var unableToRegisterError: String = {
        return AppTextService.get(AppTextKey.create_account_email_verification_view_body_unable_to_register_error)
    }()

    lazy var generalError: String = {
        return AppTextService.get(AppTextKey.create_account_email_verification_view_title_general_error)
    }()

}
