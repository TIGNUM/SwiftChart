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
    func voteTeamToBeVisionPoll(question: DTViewModel.Question,
                                votes: [DTViewModel.Answer],
                                _ completion: @escaping (QDMTeamToBeVisionPoll?) -> Void)

    func teamToBeVisionExist(_ completion: @escaping (Bool) -> Void)
    var showBanner: Bool? { get }
}

protocol DTTeamTBVRouterInterface {}
