//
//  DTTBVInterface.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol DTTBVViewControllerInterface: class {}

protocol DTTBVPresenterInterface {}

protocol DTTBVInteractorInterface: Interactor {
    func generateTBV(selectedAnswers: [SelectedAnswer],
                     questionKeyWork: String,
                     questionKeyHome: String,
                     _ completion: @escaping (QDMToBeVision?) -> Void)
}

protocol DTTBVRouterInterface {}
