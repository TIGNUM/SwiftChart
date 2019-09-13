//
//  SolveResultsRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class SolveResultsRouter {

    // MARK: - Properties
    private weak var viewController: SolveResultsViewController?

    // MARK: - Init
    init(viewController: SolveResultsViewController) {
        self.viewController = viewController
    }
}

// MARK: - SolveResultsRouterInterface
extension SolveResultsRouter: SolveResultsRouterInterface {
    func dismiss() {
        AppDelegate.current.launchHandler.dismissChatBotFlow()
    }

    func didTapDone() {
        viewController?.dismiss(animated: true, completion: {
            self.viewController?.delegate?.didFinishRec()
        })
    }

    func openStrategy(with id: Int) {
        AppDelegate.current.launchHandler.showContentCollection(id)
    }

    func openVisionGenerator() {
        let configurator = DTShortTBVConfigurator.make(introKey: ShortTBV.QuestionKey.IntroMindSet, delegate: nil)
        let controller = DTShortTBVViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }

    func openMindsetShifter() {
        let configurator = DTMindsetConfigurator.make()
        let controller = DTMindsetViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }

    func openRecovery() {
        let configurator = DTRecoveryConfigurator.make()
        let controller = DTRecoveryViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }
}
