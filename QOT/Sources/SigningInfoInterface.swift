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
    var delegate: SigningInfoDelegate? { get set }
}

protocol SigningInfoPresenterInterface {
    func setup()
    func presentUnoptimizedAlertView(title: String, message: String, dismissButtonTitle: String)
}

protocol SigningInfoInteractorInterface: Interactor {
    var title: String? { get }
    var body: String? { get }
    func didTapLoginButton()
    func didTapStartButton()
}

protocol SigningInfoRouterInterface {

}

protocol SigningInfoDelegate {
    func didTapLogin()
    func didTapStart()
}
