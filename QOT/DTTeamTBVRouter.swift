//
//  DTTeamTBVRouter.swift
//  QOT
//
//  Created by karmic on 04.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class DTTeamTBVRouter: DTRouter {
    override func dismiss() {
        dismissChatBotFlow()
    }
}

// MARK: - DTTeamTBVRouterInterface
extension DTTeamTBVRouter: DTTeamTBVRouterInterface {}
