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
    func showNextQuestion(_ viewModel: DTViewModel)
    func showPreviosQuestion(_ viewModel: DTViewModel)
    func presentInfoView(icon: UIImage?, title: String?, text: String?)
    func setNavigationButton(_ button: NavigationButton?)
    func showNavigationButtonAfterAnimation()
    func hideNavigationButtonForAnimation()
}

protocol DTPresenterInterface {    
    func showNextQuestion(_ presentationModel: DTPresentationModel, isDark: Bool)
    func showPreviousQuestion(_ presentationModel: DTPresentationModel, isDark: Bool)
    func presentInfoView(icon: UIImage?, title: String?, text: String?)
    func showNavigationButtonAfterAnimation()
    func hideNavigationButtonForAnimation()
}

protocol DTInteractorInterface: Interactor {
    func getSelectedAnswers() -> [SelectedAnswer]
    func didStopTypingAnimationPresentNextPage(viewModel: DTViewModel?)
    func didStopTypingAnimation()
    func loadNextQuestion(selection: DTSelectionModel)
    func loadPreviousQuestion()
    func getUsersTBV(_ completion: @escaping (QDMToBeVision?, Bool) -> Void)
    func didUpdateUserInput(_ text: String)
    var isDark: Bool { get set }
}

protocol DTRouterInterface {
    func dismiss()
    func presentContent(_ contentId: Int)
    func playMediaItem(_ contentItemId: Int)
}
