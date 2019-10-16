//
//  RegistrationCodeInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 10/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol RegistrationCodeViewControllerInterface: UIViewController {
    func setupView()
    func update()
    func presentFAQScreen()
}

protocol RegistrationCodePresenterInterface {
    func setup()
    func present()
    func presentActivity(state: ActivityState?)
    func presentFAQScreen()
}

protocol RegistrationCodeInteractorInterface: Interactor {
    var title: String { get }
    var description: String { get }
    var descriptionEmail: String { get }
    var preCode: String { get }
    var disclaimerError: String { get }
    var disclaimer: NSAttributedString { get }
    var codeInfo: NSAttributedString { get }
    var hasDisclaimerError: Bool { get }
    var hasCodeError: Bool { get }
    var errorMessage: String? { get }

    func didTapBack()
    func handleURLAction(url: URL)
    func toggleTermsOfUse(accepted: Bool)
    func validateLoginCode(_ code: String)
    func resetErrors()
    func resendCode()
    func showFAQScreen()
}

protocol RegistrationCodeRouterInterface {
    func showPrivacyPolicy()
    func showTermsOfUse()
    func showFAQScreen()
}
