//
//  SigningLoginInterface.swift
//  QOT
//
//  Created by karmic on 05.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

protocol SigningLoginViewControllerInterface: class {
    func setup()
    func reload(errorMessage: String?, buttonActive: Bool)
    func activateButton(_ active: Bool)
    func endEditing()
    func didResendPassword()
}

protocol SigningLoginPresenterInterface {
    func setup()
    func reload(errorMessage: String?, buttonActive: Bool)
    func activateButton(_ active: Bool)
    func endEditing()
    func didResendPassword()
}

protocol SigningLoginInteractorInterface: SigningInteractor {
    var email: String { get }
    func updatePassword(_ password: String)
    func didTabbedForgettPasswordButton()
}

protocol SigningLoginRouterInterface {
    func handleLoginError(_ error: Error)
    func handleResetPasswordError(_ error: Error)
}
