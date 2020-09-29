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

    // MARK: - Properties
    var poll: QDMTeamToBeVisionPoll?
    var team: QDMTeam?

    init(_ presenter: DTPresenterInterface,
         questionGroup: QuestionGroup,
         introKey: String,
         poll: QDMTeamToBeVisionPoll?,
         team: QDMTeam) {
        super.init(presenter, questionGroup: questionGroup, introKey: introKey)
        self.poll = poll
        self.team = team
    }

    override func getTeamTBVPoll() -> QDMTeamToBeVisionPoll? {
        return poll
    }
}

// MARK: - DTTeamTBVInteractorInterface
extension DTTeamTBVInteractor: DTTeamTBVInteractorInterface {
    func generateTBV(answers: [DTViewModel.Answer],
                     _ completion: @escaping (QDMTeamToBeVision?) -> Void) {
        if let team = team {
            createTeamToBeVision(answers: answers,
                                 team: team) { (teamTBV) in
                completion(teamTBV)
            }
        }
    }
}
