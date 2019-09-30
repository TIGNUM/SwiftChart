//
//  RegistrationInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol RegistrationViewControllerInterface: UIViewController {
    func setupView()
    func update(controller: UIViewController, direction: UIPageViewController.NavigationDirection)
    func showAlert(message: String)
    func show(alert: RegistrationExistingUserAlertViewModel)
}

protocol RegistrationPresenterInterface {
    func setupView()
    func present(alert: RegistrationExistingUserAlertViewModel)
    func present(controller: UIViewController, direction: UIPageViewController.NavigationDirection)
    func presentActivity(state: ActivityState?)
    func presentAlert(message: String)
}

protocol RegistrationInteractorInterface: Interactor {
    var currentController: UIViewController? { get }
    var totalPageCount: Int { get }
    var currentPage: Int { get }
    func navigateToLogin(shouldSaveToBeVision: Bool)
}

protocol RegistrationRouterInterface {
    func popBack()
}

protocol RegistrationDelegate: class {
    func didTapBack()
    func didVerifyEmail(_ email: String)
    func didVerifyCode(_ code: String)
    func didSave(firstName: String, lastName: String?)
    func didTapCreateAccount(with birthYear: String)
    func handleExistingUser(email: String)
}
