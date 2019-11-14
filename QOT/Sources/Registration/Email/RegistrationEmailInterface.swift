//
//  RegistrationEmailInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import UIKit

protocol RegistrationEmailViewControllerInterface: UIViewController {
    func setupView()
    func updateView()
}

protocol RegistrationEmailPresenterInterface {
    func setupView()
    func present()
    func presentActivity(state: ActivityState?)
}

protocol RegistrationEmailInteractorInterface: Interactor {
    var title: String { get }
    var emailPlaceholder: String { get }
    var nextButtonTitle: String { get }
    var isNextButtonEnabled: Bool { get }
    var isDisplayingError: Bool { get }
    var descriptionMessage: String? { get }
    var existingEmail: String? { get }

    func didTapBack()
    func didTapNext()
    func setEmail(_ email: String?)
    func resetError()
}

protocol RegistrationEmailRouterInterface { }
