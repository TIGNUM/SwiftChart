//
//  DTSolveInterface.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol DTSolveViewControllerInterface: class {}

protocol DTSolvePresenterInterface {}

protocol DTSolveInteractorInterface: Interactor {}

protocol DTSolveRouterInterface {
    func presentSolveResultView(selectedAnswer: DTViewModel.Answer)
}
