//
//  DTInterface.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol DTViewControllerInterface: class {
    func setupView(_ backgroundColor: UIColor, _ dotsColor: UIColor)
    func showNextQuestion(_ viewModel: DTViewModel)
    func showPreviosQuestion(_ viewModel: DTViewModel)
    func presentInfoView(icon: UIImage?, title: String?, text: String?)
    func setNavigationButton(_ button: NavigationButton?)
    func showNavigationButtonAfterAnimation()
    func hideNavigationButtonForAnimation()
}

protocol DTPresenterInterface {
    func setupView()
    func showNextQuestion(_ presentationModel: DTPresentationModel)
    func showPreviosQuestion(_ presentationModel: DTPresentationModel)
    func presentInfoView(icon: UIImage?, title: String?, text: String?)
    func showNavigationButtonAfterAnimation()
    func hideNavigationButtonForAnimation()
}

protocol DTInteractorInterface: Interactor {
    func getTBV() -> QDMToBeVision?
    func getSelectedAnswers() -> [SelectedAnswer]
    func didStopTypingAnimationPresentNextPage(viewModel: DTViewModel?)
    func didStopTypingAnimation()
    func loadNextQuestion(selection: DTSelectionModel)
    func loadPreviousQuestion()
    func getUsersTBV(_ completion: @escaping (QDMToBeVision?, Bool) -> Void)
    func getTBV() -> QDMToBeVision?
    func getSelectedAnswers() -> [SelectedAnswer]
}

protocol DTRouterInterface {
    func dismiss()
}
