//
//  PrepareResultsConfigurator.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class PrepareResultsConfigurator {
    static func configurate(_ preparation: QDMUserPreparation,
                            _ answers: [DecisionTreeModel.SelectedAnswer],
                            _ relatedStrategyId: Int,
                            canDelete: Bool) -> (PrepareResultsViewController) -> Void {
        return { (viewController) in
            let router = PrepareResultsRouter(viewController: viewController)
            let worker = PrepareResultsWorker(preparation, answers, relatedStrategyId, canDelete)
            let presenter = PrepareResultsPresenter(viewController: viewController)
            let interactor = PrepareResultInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
            worker.delegate = viewController
        }
    }

    static func configurate(_ contentId: Int) -> (PrepareResultsViewController) -> Void {
        return { (viewController) in
            let router = PrepareResultsRouter(viewController: viewController)
            let worker = PrepareResultsWorker(contentId)
            let presenter = PrepareResultsPresenter(viewController: viewController)
            let interactor = PrepareResultInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
            worker.delegate = viewController
        }
    }
}
