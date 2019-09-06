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
        return ScreenTitleService.main.localizedString(for: .OnboardingRegistrationCreateAccountError)
    }()

    lazy var existingAccountAlertTitle: String = {
        return ScreenTitleService.main.localizedString(for: .OnboardingRegistrationEmailErrorExistingEmailTitle)
    }()

    lazy var existingAccountAlertMessage: String = {
        return ScreenTitleService.main.localizedString(for: .OnboardingRegistrationEmailErrorExistingEmail)
    }()

    lazy var yesButtonTitle: String = {
        return ScreenTitleService.main.localizedString(for: .OnboardingRegistrationEmailButtonYes)
    }()

    lazy var noButtonTitle: String = {
        return ScreenTitleService.main.localizedString(for: .OnboardingRegistrationEmailButtonNo)
    }()

    // MARK: - Init

    init(_ sessionService: SessionService = SessionService.main,
         _ userService: qot_dal.UserService = qot_dal.UserService.main) {
        super.init(sessionService, userService)
    }

    func createAccount(with data: RegistrationData,
                       _ completion: @escaping (_ response: ApiResponse, _ error: Error?) -> Void) {
        var userObject = QDMRegistrationRequest()
        userObject.email = data.email
        userObject.code = data.code
        userObject.firstName = data.firstName
        userObject.lastName = data.lastName
        userObject.birthYear = data.birthYear
        sessionService.registUser(request: userObject) { [weak self] (response, error) in
            guard let strongSelf = self else { return }
            let result = (code: strongSelf.apiCodeFromResponse(response?.returnCode()), message: response?.message)
            completion(result, error)
            requestSynchronization(.USER, .DOWN_SYNC)
        }
    }
}
