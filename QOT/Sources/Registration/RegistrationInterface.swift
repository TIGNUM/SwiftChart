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
}

protocol RegistrationPresenterInterface {
    func setupView()
    func present(controller: UIViewController, direction: UIPageViewController.NavigationDirection)
    func presentActivity(state: ActivityState?)
    func presentAlert(message: String)
}

protocol RegistrationInteractorInterface: Interactor {
    var currentController: UIViewController? { get }
    var totalPageCount: Int { get }
    var currentPage: Int { get }
}

protocol RegistrationRouterInterface {
    func popBack()
    func showCoachMarksViewController()
}

protocol RegistrationDelegate: class {
    func didTapBack()
    func didVerifyEmail(_ email: String, existingUser: Bool)
    func didVerifyCode(_ code: String)
    func didSave(firstName: String, lastName: String?)
    func didTapCreateAccount(with birthYear: String)
}
