//
//  DTRouter.swift
//  QOT
//
//  Created by karmic on 10.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

class DTRouter: DTRouterInterface {
    func dismiss() {
        AppDelegate.current.launchHandler.dismissChatBotFlow()
    }

    func openTBVGenerator() {

    }
}
