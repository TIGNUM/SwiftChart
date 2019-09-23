//
//  DTShortTBVInterface.swift
//  QOT
//
//  Created by karmic on 10.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol DTShortTBVViewControllerInterface: class {}

protocol DTShortTBVPresenterInterface {}

protocol DTShortTBVDelegate: class {
    func didTapBack()
    func didDismissShortTBVScene(tbv: QDMToBeVision?)
}
extension DTShortTBVDelegate {
    func didTapBack() { /* nop - making the method optional as it's used only in onboarding */ }
}

protocol DTShortTBVInteractorInterface: Interactor {    
    var canGoBack: Bool { get }
    var shouldDismissOnContinue: Bool { get }
    func getTBV() -> QDMToBeVision?
    func generateTBV(selectedAnswers: [SelectedAnswer],
                     questionKeyWork: String,
                     questionKeyHome: String,
                     _ completion: @escaping (QDMToBeVision?) -> Void)
}

protocol DTShortTBVRouterInterface {
    func dismissShortTBVFlow()
}
