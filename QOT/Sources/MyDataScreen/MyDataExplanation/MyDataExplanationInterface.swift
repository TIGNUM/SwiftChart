//
//  MyDataExplanationInterface.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyDataExplanationViewControllerInterface: class {
    func setupView()
}

protocol MyDataExplanationPresenterInterface {
    func setupView()
}

protocol MyDataExplanationInteractorInterface: Interactor {}

protocol MyDataExplanationRouterInterface {
    func dismiss()
}
