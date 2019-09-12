//
//  ResultInterface.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol ResultViewControllerInterface: class {
    func setupView()
}

protocol ResultPresenterInterface {
    func setupView()
}

protocol ResultInteractorInterface: Interactor {}

protocol ResultRouterInterface {
    func dismiss()
}
