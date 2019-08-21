//
//  OnoardingLoginInterface.swift
//  QOT
//
//  Created by karmic on 29.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol OnoardingLoginViewControllerInterface: class {
    func setupView()
}

protocol OnoardingLoginPresenterInterface {
    func setupView()
}

protocol OnoardingLoginInteractorInterface: Interactor {}

protocol OnoardingLoginRouterInterface {}
