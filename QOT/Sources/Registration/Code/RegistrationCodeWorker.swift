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
        return AppTextService.get(AppTextKey.create_account_code_verification_view_title)
    }()

    lazy var description: String = {
        return AppTextService.get(AppTextKey.create_account_code_verification_view_description_title)
    }()

    lazy var preCode: String = {
        return AppTextService.get(AppTextKey.create_account_code_verification_view_code_title)
    }()

    lazy var disclaimerError: String = {
        return AppTextService.get(AppTextKey.create_account_code_verification_view_disclaimer_error_title)
    }()

    lazy var disclaimer: String = {
        return AppTextService.get(AppTextKey.create_account_code_verification_view_disclaimer_title)
    }()

    lazy var disclaimerTermsPlaceholder: String = {
        return AppTextService.get(AppTextKey.create_account_code_verification_view_disclaimer_terms_placeholder_title)
    }()

    lazy var disclaimerPrivacyPlaceholder: String = {
        return AppTextService.get(AppTextKey.create_account_code_verification_view_disclaimer_privacy_placeholder_title)
    }()

    lazy var codeInfo: String = {
        return AppTextService.get(AppTextKey.create_account_code_verification_view_code_info_title)
    }()

    lazy var changeEmail: String = {
        return AppTextService.get(AppTextKey.create_account_code_verification_view_change_email_title)
    }()

    lazy var sendAgain: String = {
        return AppTextService.get(AppTextKey.create_account_code_verification_view_send_again_title)
    }()

    lazy var help: String = {
        return AppTextService.get(AppTextKey.create_account_code_verification_view_help_title)
    }()

    lazy var codeError: String = {
        return AppTextService.get(AppTextKey.create_account_code_verification_view_send_code_error_title)
    }()

    lazy var resendCodeError: String = {
        return AppTextService.get(AppTextKey.create_account_code_verification_view_send_code_error_title)
    }()
}
