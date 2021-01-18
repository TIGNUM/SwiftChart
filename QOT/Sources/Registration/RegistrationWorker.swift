//
//  RegistrationWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class RegistrationWorker: BaseSigningWorker {

    // MARK: - Properties

    lazy var generalError: String = {
        return AppTextService.get(.onboarding_sign_up_age_verification_alert_email_error_body)
    }()

    lazy var existingAccountAlertTitle: String = {
        return AppTextService.get(.onboarding_sign_up_email_verification_alert_account_exist_title)
    }()

    lazy var existingAccountAlertMessage: String = {
        return AppTextService.get(.onboarding_sign_up_email_verification_alert_account_exist_body)
    }()

    lazy var yesButtonTitle: String = {
        return AppTextService.get(.onboarding_sign_up_email_verification_alert_account_exist_button_save)
    }()

    lazy var noButtonTitle: String = {
        return AppTextService.get(.onboarding_sign_up_email_verification_alert_account_exist_button_dismiss)
    }()

    // MARK: - Init

    override init(_ sessionService: SessionService = SessionService.main,
                  _ userService: UserService = UserService.main) {
        super.init(sessionService, userService)
    }

    func createAccount(with data: RegistrationData,
                       _ completion: @escaping (_ response: ApiResponse, _ error: Error?) -> Void) {
        var userObject = QDMRegistrationRequest()
        userObject.email = data.email
        userObject.code = data.code
        userObject.firstName = data.firstName
        userObject.lastName = data.lastName
        userObject.birthYear = "1000-01-01"
        sessionService.registUser(request: userObject) { [weak self] (response, error) in
            guard let strongSelf = self else { return }
            let result = (code: strongSelf.apiCodeFromResponse(response?.returnCode()), message: response?.message)
            completion(result, error)
            requestSynchronization(.USER, .DOWN_SYNC)
        }
    }
}
