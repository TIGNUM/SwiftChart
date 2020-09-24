//
//  DTTeamTBVInteractor.swift
//  QOT
//
//  Created by karmic on 04.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTTeamTBVInteractor: DTInteractor, WorkerTeam {

    var poll: QDMTeamToBeVisionPoll?

    init(_ presenter: DTPresenterInterface,
         questionGroup: QuestionGroup,
         introKey: String,
         poll: QDMTeamToBeVisionPoll?) {
        super.init(presenter, questionGroup: questionGroup, introKey: introKey)
        self.poll = poll
    }

    override func getTeamTBVPoll() -> QDMTeamToBeVisionPoll? {
        return poll
    }
}

// MARK: - DTTeamTBVInteractorInterface
extension DTTeamTBVInteractor: DTTeamTBVInteractorInterface {}
