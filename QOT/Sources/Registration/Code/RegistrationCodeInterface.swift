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
    func presentGetHelpView()
}

protocol RegistrationCodePresenterInterface {
    func setup()
    func present()
    func presentActivity(state: ActivityState?)
    func presentGetHelp()
}

protocol RegistrationCodeInteractorInterface: Interactor {
    var title: String { get }
    var description: NSAttributedString { get }
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
}

protocol RegistrationCodeRouterInterface {
    func showPrivacyPolicy()
    func showTermsOfUse()
}
