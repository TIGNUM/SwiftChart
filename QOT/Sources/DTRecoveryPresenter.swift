//
//  DTRecoveryPresenter.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTRecoveryPresenter: DTPresenter {

    override func previousIsHidden(questionKey: String) -> Bool {
        return questionKey == Recovery.QuestionKey.Intro
    }
}

// MARK: - DTRecoveryInterface
extension DTRecoveryPresenter: DTRecoveryPresenterInterface {}
