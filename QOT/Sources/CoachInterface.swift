//
//  CoachInterface.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol CoachViewControllerInterface: class {
    func setupView()
}

protocol CoachPresenterInterface {
    func setupView()
}

protocol CoachInteractorInterface: Interactor {}

protocol CoachRouterInterface {}
