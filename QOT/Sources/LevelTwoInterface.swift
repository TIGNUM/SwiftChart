//
//  LevelTwoInterface.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol LevelTwoViewControllerInterface: class {
    func setupView()
    func presentLevelThree()
}

protocol LevelTwoPresenterInterface {
    func setupView()
}

protocol LevelTwoInteractorInterface: Interactor {
    func didTabCell(at: IndexPath)
}

protocol LevelTwoRouterInterface {
    func didTabCell(at: IndexPath)
}
