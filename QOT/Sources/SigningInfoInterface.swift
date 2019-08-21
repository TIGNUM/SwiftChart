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
    var delegate: SigningInfoDelegate? { get set }
}

protocol SigningInfoPresenterInterface {
    func setup()
}

protocol SigningInfoInteractorInterface: Interactor {
    func didTapBottomButton()
    func title(at item: Int) -> String?
    func body(at item: Int) -> String?
    func didTapLoginButton()
    func didTapStartButton()
}

protocol SigningInfoRouterInterface {
    func presentSigningEmailView()
}

protocol SigningInfoDelegate {
    func didTapLogin()
    func didTapStart()
}
