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
    private let service: QOTService

    lazy var generalError: String = {
        R.string.localized.onboardingRegistrationCreateAccountError()
    }()

    lazy var existingAccountAlertTitle: String = {
        return R.string.localized.onboardingRegistrationEmailErrorExistingEmailTitle()
    }()

    lazy var existingAccountAlertMessage: String = {
        return R.string.localized.onboardingRegistrationEmailErrorExistingEmail()
    }()

    lazy var yesButtonTitle: String = {
        return R.string.localized.onboardingRegistrationEmailButtonYes()
    }()

    lazy var noButtonTitle: String = {
        return R.string.localized.onboardingRegistrationEmailButtonNo()
    }()

    // MARK: - Init

    init(_ service: QOTService = QOTService.main,
         _ sessionService: SessionService = SessionService.main,
         _ userService: qot_dal.UserService = qot_dal.UserService.main) {
        self.service = service
        super.init(sessionService, userService)
    }

    func createAccount(with data: RegistrationData,
                       _ completion: @escaping (_ response: ApiResponseResult, _ error: Error?) -> Void) {
        var userObject = QDMRegistrationRequest()
        userObject.email = data.email
        userObject.code = data.code
        userObject.firstName = data.firstName
        userObject.lastName = data.lastName
        userObject.birthYear = data.birthYear
        service.createUser(request: userObject) { [weak self] (response, error) in
            guard let strongSelf = self else { return }
            completion(strongSelf.apiCodeFromResponse(response?.returnCode()), error)
            requestSynchronization(.USER, .DOWN_SYNC)
        }
    }
}
