//
//  DTSolveInterface.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol DTSolveViewControllerInterface: class {}

protocol DTSolvePresenterInterface {}

protocol DTSolveInteractorInterface: Interactor {
    func didDismissShortTBVScene(tbv: QDMToBeVision?)
}

protocol DTSolveRouterInterface {
    func presentSolveResults(selectedAnswer: DTViewModel.Answer)
    func loadShortTBVGenerator(introKey: String, delegate: DTShortTBVDelegate?, completion: (() -> Void)?)
    func dismissFlowAndGoToMyTBV()
}
