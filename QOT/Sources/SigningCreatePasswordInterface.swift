//
//  SigningCreatePasswordInterface.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

protocol SigningCreatePasswordViewControllerInterface: class {
    func setup()
    func reload(errorMessage: String?, buttonActive: Bool)
    func hideErrorMessage()
    func activateButton(_ active: Bool)
    func endEditing()
}

protocol SigningCreatePasswordPresenterInterface {
    func setup()
    func reload(errorMessage: String?, buttonActive: Bool)
    func hideErrorMessage()
    func activateButton(_ active: Bool)
    func endEditing()
}

protocol SigningCreatePasswordInteractorInterface: SigningInteractor {}

protocol SigningCreatePasswordRouterInterface {
    func showCountryView(email: String, code: String, password: String)
}
