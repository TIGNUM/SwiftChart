//
//  SigningEmailInterface.swift
//  QOT
//
//  Created by karmic on 29.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

protocol SigningInteractor: Interactor {
    func didTapNext()
    func updateWorkerValue(for formType: FormView.FormType?)
}

protocol SigningEmailViewControllerInterface: class {
    func setup()
    func reload(errorMessage: String?, buttonActive: Bool)
    func hideErrorMessage()
    func activateButton(_ active: Bool)
    func endEditing()
}

protocol SigningEmailPresenterInterface {
    func setup()
    func reload(errorMessage: String?, buttonActive: Bool)
    func hideErrorMessage()
    func activateButton(_ active: Bool)
    func endEditing()
}

protocol SigningEmailInteractorInterface: SigningInteractor {}

protocol SigningEmailRouterInterface {
    func openDigitVerificationView(email: String)
    func openSignInView(email: String)
}
