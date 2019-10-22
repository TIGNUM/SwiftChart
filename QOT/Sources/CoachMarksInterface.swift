//
//  CoachMarksInterface.swift
//  QOT
//
//  Created by karmic on 22.10.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol CoachMarksViewControllerInterface: class {
    func setupView()
}

protocol CoachMarksPresenterInterface {
    func setupView()
}

protocol CoachMarksInteractorInterface: Interactor {}

protocol CoachMarksRouterInterface {
    func dismiss()
}
