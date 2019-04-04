//
//  MyQotInterface.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyQotViewControllerInterface: class {
    func setupView()
}

protocol MyQotPresenterInterface {
    func setupView()
}

protocol MyQotInteractorInterface: Interactor {}

protocol MyQotRouterInterface {}
