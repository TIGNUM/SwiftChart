//
//  BaseSigningWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 09/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

enum ApiResponseResult {
    case valid
    case invalid
    case codeSent
    case codeValid
    case codeInvalid
    case userCreated
    case userExists
    case noSubscription
    case userDoesNotExist
    case unableToRegister
    case appVersionInvalid
}

class BaseSigningWorker {
    typealias ApiResponse = (code: ApiResponseResult, message: String?)

    // MARK: - Properties

    let sessionService: SessionService
    let userService: qot_dal.UserService
    let titleService: ScreenTitleService

    // MARK: - Init

    init(_ sessionService: SessionService = SessionService.main,
         _ userService: qot_dal.UserService = qot_dal.UserService.main,
         _ contentService: ScreenTitleService = qot_dal.ScreenTitleService.main) {
        self.sessionService = sessionService
        self.userService = userService
        self.titleService = contentService
    }
}

// MARK: - Public methods

extension BaseSigningWorker {

    func verifyEmail(_ email: String, _ completion: @escaping (_ response: ApiResponse, _ error: Error?) -> Void) {
        sessionService.verify(email: email) { [weak self] (response, error) in
            guard let strongSelf = self else { return }
            completion(strongSelf.response(from: response), error)
        }
    }

    func requestCode(for email: String, _ completion: @escaping (_ response: ApiResponse, _ error: Error?) -> Void) {
        sessionService.requestVerificationCode(for: email) { [weak self] (response, error) in
            guard let strongSelf = self else { return }
            completion(strongSelf.response(from: response), error)
        }
    }

    func validate(code: String, for email: String, forLogin: Bool, _ completion: @escaping (_ response: ApiResponse, _ error: Error?) -> Void) {
        sessionService.verify(code: code, email: email, forLogin: forLogin) { [weak self] (response, error) in
            guard let strongSelf = self else { return }
            completion(strongSelf.response(from: response), error)
        }
    }

    func isValidEmail(_ email: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }

    func updateToBeVision(with cachedVision: QDMToBeVision) {
        userService.updateMyToBeVision(cachedVision) { (error) in
            guard let error = error else { return }
            qot_dal.log("Failed to save user's ToBeVision: \(error)", level: .debug)
        }
    }
}

// MARK: - Helper methods

extension BaseSigningWorker {

    func response(from response: QDMVerificationResponse?) -> ApiResponse {
        return (code: apiCodeFromResponse(response?.returnCode()), message: response?.message)
    }

    func apiCodeFromResponse(_ code: ReturnCode?) -> ApiResponseResult {
        guard let code = code else { return .invalid }
        switch code {
        case .VALID: return .valid
        case .VERIFICATIONCODE_SENT: return .codeSent
        case .VERIFICATIONCODE_VALID: return .codeValid
        case .VERIFICATIONCODE_EXPIRED,
             .VERIFICATIONCODE_INVALID: return .codeInvalid
        case .USER_CREATED: return .userCreated
        case .USER_EXIST: return .userExists
        case .REGISTRATION_NOT_ALLOWED: return .unableToRegister
        case .INVALID_APP_VERSION: return .appVersionInvalid
        case .USER_DOESNT_EXIST: return .userDoesNotExist
        case .SUBSCRIPTION_DOES_NOT_EXIST: return .noSubscription
        default: return .invalid
        }
    }
}
