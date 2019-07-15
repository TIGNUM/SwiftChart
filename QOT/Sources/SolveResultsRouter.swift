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
            .instantiateViewController(withIdentifier: "QOT.ArticleViewController") as? ArticleViewController {
            ArticleConfigurator.configure(selectedID: id, viewController: controller)
            viewController.present(controller, animated: true, completion: nil)
        }
    }

    func openVisionGenerator() {
        let configurator = DecisionTreeConfigurator.make(for: .toBeVisionGenerator)
        let decisionTreeController = DecisionTreeViewController(configure: configurator)
        viewController.present(decisionTreeController, animated: true)
    }

    func openMindsetShifter() {
        let configurator = DecisionTreeConfigurator.make(for: .mindsetShifter)
        let decisionTreeController = DecisionTreeViewController(configure: configurator)
        viewController.present(decisionTreeController, animated: true)
    }

    func openConfirmationView() {
        let configurator = ConfirmationConfigurator.make(for: .solve)
        let confirmationVC = ConfirmationViewController(configure: configurator)
        confirmationVC.delegate = viewController
        viewController.present(confirmationVC, animated: true)
    }
}
