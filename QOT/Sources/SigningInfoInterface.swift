//
//  SigningInfoInterface.swift
//  QOT
//
//  Created by karmic on 28.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

protocol SigningInfoViewControllerInterface: UIViewController {
    func setup()
    func presentUnoptimizedAlertView(title: String, message: String, dismissButtonTitle: String)
    func didFinishLogin()
}

protocol SigningInfoPresenterInterface {
    func setup()
    func presentUnoptimizedAlertView(title: String, message: String, dismissButtonTitle: String)
}

protocol SigningInfoInteractorInterface: Interactor {
    var titleText: String? { get }
    var bodyText: String? { get }
    func didTapLoginButton()
    func didTapStartButton()
}

protocol SigningInfoRouterInterface {
    func goToRegister(fromLogin: Bool)
    func goToLogin()
}
