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
        presentDecisionTree(type: .toBeVisionGenerator)
    }

    func openMindsetShifter() {
        presentDecisionTree(type: .mindsetShifter)
    }

    func openRecovery() {
        presentDecisionTree(type: .recovery)
    }
}

// MARK: - Private
private extension SolveResultsRouter {
    func presentDecisionTree(type: DecisionTreeType) {
        let configurator = DecisionTreeConfigurator.make(for: type)
        let decisionTreeController = DecisionTreeViewController(configure: configurator)
        viewController?.present(decisionTreeController, animated: true)
    }
}
