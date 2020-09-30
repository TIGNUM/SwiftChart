//
//  DTTeamTBVInterface.swift
//  QOT
//
//  Created by karmic on 04.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol DTTeamTBVViewControllerInterface: class {}

protocol DTTeamTBVPresenterInterface {}

protocol DTTeamTBVInteractorInterface: Interactor {
    func generateTBV(answers: [DTViewModel.Answer],
                     _ completion: @escaping (QDMTeamToBeVision?) -> Void)

    func voteTeamToBeVisionPoll(question: DTViewModel.Question,
                                votes: [DTViewModel.Answer],
                                _ completion: @escaping (QDMTeamToBeVisionPoll?) -> Void)
}

protocol DTTeamTBVRouterInterface {}
