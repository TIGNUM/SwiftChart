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
}

protocol RegistrationNamesPresenterInterface {
    func setupView()
}

protocol RegistrationNamesInteractorInterface: Interactor {
    var title: String { get }
    var firstNameTitle: String { get }
    var lastNameTitle: String { get }
    var mandatoryText: String { get }
    var nextButtonTitle: String { get }

    func didTapBack()
    func didTapNext(with firstName: String, lastName: String?)
}

protocol RegistrationNamesRouterInterface {}
