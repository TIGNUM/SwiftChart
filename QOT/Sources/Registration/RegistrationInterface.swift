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
    func updateView()
    func update(controller: UIViewController, direction: UIPageViewController.NavigationDirection)
    func showAlert(message: String)
}

protocol RegistrationPresenterInterface {
    var navigationController: UINavigationController { get }
    func setupView()
    func presentView()
    func present(controller: UIViewController, direction: UIPageViewController.NavigationDirection)
    func presentActivity(state: ActivityState?)
    func presentAlert(message: String)
}

protocol RegistrationInteractorInterface: Interactor {
    var currentController: UIViewController? { get }
    var totalPageCount: Int { get }
    var currentPage: Int { get }
    var existingUserAlertViewModel: RegistrationExistingUserAlertViewModel? { get }
    func navigateToLogin(shouldSaveToBeVision: Bool)
}

protocol RegistrationRouterInterface {
    func popBack()
    func showLocationPersmission(completion: (() -> Void)?)
}

protocol RegistrationDelegate {
    func didTapBack()
    func didVerifyEmail(_ email: String)
    func didVerifyCode(_ code: String)
    func didSave(firstName: String, lastName: String?)
    func didTapCreateAccount(with birthYear: String)
    func handleExistingUser(email: String)
}
