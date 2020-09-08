//
//  DTTeamTBVPresenter.swift
//  QOT
//
//  Created by karmic on 04.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class DTTeamTBVPresenter: DTPresenter {
    override func previousIsHidden(questionKey: String) -> Bool {
        return true
    }
}

// MARK: - DTTeamTBVInterface
extension DTTeamTBVPresenter: DTTeamTBVPresenterInterface {}
