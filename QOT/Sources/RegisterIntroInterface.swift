//
//  RegisterIntroInterface.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 05/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol RegisterIntroViewControllerInterface: class {
    func setupView()
}

protocol RegisterIntroPresenterInterface {
    func setupView()
}

protocol RegisterIntroInteractorInterface: Interactor {}

protocol RegisterIntroRouterInterface {
    func dismiss()
    func openRegistration()
}
