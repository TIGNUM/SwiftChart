//
//  DTTeamTBVPresenter.swift
//  QOT
//
//  Created by karmic on 04.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTTeamTBVPresenter: DTPresenter {
    override func previousIsHidden(questionKey: String) -> Bool {
        return true
    }

    override func getVotes(answer: QDMAnswer, poll: QDMTeamToBeVisionPoll?) -> Int {
        return poll?.voteResults.filter { $0.answer?.remoteID == answer.remoteID }.first?.count ?? .zero
    }
}

// MARK: - DTTeamTBVInterface
extension DTTeamTBVPresenter: DTTeamTBVPresenterInterface {}
