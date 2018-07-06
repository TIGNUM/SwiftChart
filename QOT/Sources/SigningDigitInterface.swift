//
//  SigningDigitInterface.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

protocol SigningDigitViewControllerInterface: class {
    func setup(code: String?)
    func reload(errorMessage: String?, buttonActive: Bool)
    func activateButton(_ active: Bool)
    func endEditing()
}

protocol SigningDigitPresenterInterface {
    func setup(code: String?)
    func reload(errorMessage: String?, buttonActive: Bool)
    func activateButton(_ active: Bool)
    func endEditing()
}

protocol SigningDigitInteractorInterface: SigningInteractor {
    var email: String { get }
    func verify(code: String)
    func resendCode()
}

protocol SigningDigitRouterInterface {
    func openCreatePasswordView(userSigning: UserSigning,
                                responseType: UserRegistrationCheck.ResponseType)
    func openEnterEmailView()
}
