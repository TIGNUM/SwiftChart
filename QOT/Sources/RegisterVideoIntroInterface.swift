//
//  RegisterVideoIntroInterface.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 29/11/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol RegisterVideoIntroViewControllerInterface: class {
    func setupView()
}

protocol RegisterVideoIntroPresenterInterface {
    func setupView()
}

protocol RegisterVideoIntroInteractorInterface: Interactor {
    func didTapBack()
}

protocol RegisterVideoIntroRouterInterface {
    func openRegistration()
}
