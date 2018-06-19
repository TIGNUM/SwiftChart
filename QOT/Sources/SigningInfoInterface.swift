//
//  SigningInfoInterface.swift
//  QOT
//
//  Created by karmic on 28.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

protocol SigningInfoViewControllerInterface: class {
    func setup()
}

protocol SigningInfoPresenterInterface {
    func setup()
}

protocol SigningInfoInteractorInterface: Interactor {
    func didTapBottomButton()
}

protocol SigningInfoRouterInterface {
    func presentSigningEmailView()
}
