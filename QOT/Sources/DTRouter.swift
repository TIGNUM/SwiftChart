//
//  DTRouter.swift
//  QOT
//
//  Created by karmic on 10.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

class DTRouter: DTRouterInterface {

    // MARK: - Properties
    weak var viewController: DTViewController?

    // MARK: - Init
    init(viewController: DTViewController?) {
        self.viewController = viewController
    }

    // MARK: - DTRouterInterface
    func dismiss() {
        AppDelegate.current.launchHandler.dismissChatBotFlow()
    }

    func loadShortTBVGenerator(introKey: String) {
        let configurator = DTShortTBVConfigurator.make(introKey: ShortTBV.QuestionKey.IntroMindSet)
        let controller = DTShortTBVViewController(configure: configurator)
        viewController?.present(controller, animated: true, completion: nil)
    }
}
