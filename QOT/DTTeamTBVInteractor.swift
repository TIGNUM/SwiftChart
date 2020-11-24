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
    var showBanner: Bool?

    init(_ presenter: DTPresenterInterface,
         questionGroup: QuestionGroup,
         introKey: String,
         showBanner: Bool?,
         poll: QDMTeamToBeVisionPoll?,
         team: QDMTeam) {
        super.init(presenter, questionGroup: questionGroup, introKey: introKey)
        self.poll = poll
        self.team = team
        self.showBanner = showBanner
    }

    override func getTeamTBVPoll() -> QDMTeamToBeVisionPoll? {
        return poll
    }
}

// MARK: - DTTeamTBVInteractorInterface
extension DTTeamTBVInteractor: DTTeamTBVInteractorInterface {
    func voteTeamToBeVisionPoll(question: DTViewModel.Question,
                                votes: [DTViewModel.Answer],
                                _ completion: @escaping (QDMTeamToBeVisionPoll?) -> Void) {
        if let poll = poll {
            QuestionService.main.question(with: question.remoteId) { (qdmQuestion) in
                if let qdmQuestion = qdmQuestion {
                    let votesIds = votes.compactMap { $0.remoteId }
                    var qdmAnswers = [QDMAnswer]()
                    qdmQuestion.answers.forEach { (qdmAnswer) in
                        if votesIds.contains(obj: qdmAnswer.remoteID) {
                            qdmAnswers.append(qdmAnswer)
                        }
                    }
                    self.voteTeamToBeVisionPoll(poll,
                                                question: qdmQuestion,
                                                votes: qdmAnswers) { (poll) in
                        completion(poll)
                    }
                }
            }
        }
    }

    func teamToBeVisionExist(_ completion: @escaping (Bool) -> Void) {
        if let team = team {
            getTeamToBeVision(for: team) { (teamVision) in
                completion(teamVision != nil)
            }
        } else {
            completion(false)
        }
    }
}
