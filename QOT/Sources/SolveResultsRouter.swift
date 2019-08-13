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
    private let viewController: SolveResultsViewController

    // MARK: - Init
    init(viewController: SolveResultsViewController) {
        self.viewController = viewController
    }
}

// MARK: - SolveResultsRouterInterface
extension SolveResultsRouter: SolveResultsRouterInterface {
    func dismiss() {
        viewController.dismiss(animated: true, completion: {
            self.viewController.delegate?.didFinishSolve()
        })
    }

    func openStrategy(with id: Int) {
        if let controller = R.storyboard.main()
            .instantiateViewController(withIdentifier: R.storyboard.main.qotArticleViewController.identifier)
            as? ArticleViewController {
                ArticleConfigurator.configure(selectedID: id, viewController: controller)
                viewController.present(controller, animated: true, completion: nil)
        }
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

    func openConfirmationView(_ kind: Confirmation.Kind) {
        let configurator = ConfirmationConfigurator.make(for: kind)
        let confirmationVC = ConfirmationViewController(configure: configurator)
        confirmationVC.delegate = viewController
        viewController.present(confirmationVC, animated: true)
    }
}

// MARK: - Private
private extension SolveResultsRouter {
    func presentDecisionTree(type: DecisionTreeType) {
        let configurator = DecisionTreeConfigurator.make(for: type)
        let decisionTreeController = DecisionTreeViewController(configure: configurator)
        viewController.present(decisionTreeController, animated: true)
    }
}
