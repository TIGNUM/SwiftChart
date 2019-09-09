//
//  DTSprintInterface.swift
//  QOT
//
//  Created by karmic on 07.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol DTSprintViewControllerInterface: class {
    func setupView(_ backgroundColor: UIColor, _ dotsColor: UIColor)
    func showNextQuestion(_ viewModel: ViewModel)
    func showPreviosQuestion(_ viewModel: ViewModel)
    func presentInfoView(icon: UIImage?, title: String?, text: String?)
}

protocol DTSprintPresenterInterface {
    func setupView()
    func showNextQuestion(_ presentationModel: PresentationModel)
    func showPreviosQuestion(_ presentationModel: PresentationModel)
    func presentInfoView(icon: UIImage?, title: String?, text: String?)
}

protocol DTSprintInteractorInterface: Interactor {
    func didStopTypingAnimation(answer: ViewModel.Answer?)
    func loadNextQuestion(selection: SelectionModel)
    func loadPreviousQuestion()
    func startSprintTomorrow(selection: SelectionModel)
    func stopActiveSprintAndStartNewSprint()
    func addSprintToQueue(selection: SelectionModel)
    func getSelectedSprintTitle() -> String?
}

protocol DTSprintRouterInterface {
    func dismiss()
}
