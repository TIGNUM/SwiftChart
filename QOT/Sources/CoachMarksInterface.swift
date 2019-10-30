//
//  CoachMarksInterface.swift
//  QOT
//
//  Created by karmic on 22.10.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol CoachMarksViewControllerInterface: class {
    func setupView(_ viewModel: CoachMark.ViewModel)
    func updateView(_ viewModel: CoachMark.ViewModel)
}

protocol CoachMarksPresenterInterface {
    func setupView(_ step: CoachMark.Step)
    func updateView(_ step: CoachMark.Step)
}

protocol CoachMarksInteractorInterface: Interactor {
    func loadNextStep(page: Int)
    func loadPreviousStep(page: Int)
}

protocol CoachMarksRouterInterface {
    func dismiss()
}
