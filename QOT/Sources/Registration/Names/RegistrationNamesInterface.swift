//
//  RegistrationNamesInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 12/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol RegistrationNamesViewControllerInterface: class {
    func setupView()
    func updateView()
}

protocol RegistrationNamesPresenterInterface {
    func setupView()
    func presentView()
}

protocol RegistrationNamesInteractorInterface: Interactor {
    var title: String { get }
    var firstNameTitle: String { get }
    var lastNameTitle: String { get }
    var mandatoryText: String { get }
    var nextButtonTitle: String { get }
    var hasFirstNameError: Bool { get }
    var hasLastNameError: Bool { get }

    func didTapBack()
    func didTapNext(with firstName: String, lastName: String?)
    func resetErrors()
}

protocol RegistrationNamesRouterInterface {}
