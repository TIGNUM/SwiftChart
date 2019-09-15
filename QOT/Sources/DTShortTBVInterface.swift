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
    func didDismissShortTBVScene(tbv: QDMToBeVision?)
}

protocol DTShortTBVInteractorInterface: Interactor {
    func getTBV() -> QDMToBeVision?
    func generateTBV(selectedAnswers: [SelectedAnswer],
                     questionKeyWork: String,
                     questionKeyHome: String,
                     _ completion: @escaping (QDMToBeVision?) -> Void)
}

protocol DTShortTBVRouterInterface {
    func dismiss()
}
