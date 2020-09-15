//
//  TeamToBeVisionOptionsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol TeamToBeVisionOptionsViewControllerInterface: class {
    func setupView()
}

protocol TeamToBeVisionOptionsPresenterInterface {
    func setupView()
}

protocol TeamToBeVisionOptionsInteractorInterface: Interactor {}

protocol TeamToBeVisionOptionsRouterInterface {
    func dismiss()
}
