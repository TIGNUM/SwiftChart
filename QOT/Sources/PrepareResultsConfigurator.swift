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
//    /// Daily && Critical
//    static func configurate(_ preparation: QDMUserPreparation,
//                            _ answers: [DecisionTreeModel.SelectedAnswer],
//                            canDelete: Bool,
//                            _ dataModified: Bool = false) -> (PrepareResultsViewController) -> Void {
//        return { (viewController) in
//            let router = PrepareResultsRouter(viewController: viewController)
//            let worker = PrepareResultsWorker(preparation, answers, canDelete, dataModified)
//            let presenter = PrepareResultsPresenter(viewController: viewController)
//            let interactor = PrepareResultInteractor(worker: worker, presenter: presenter, router: router)
//            viewController.interactor = interactor
//            worker.delegate = viewController
//        }
//    }

    static func make(_ preparation: QDMUserPreparation?, canDelete: Bool) -> (PrepareResultsViewController) -> Void {
        return { (viewController) in
            let router = PrepareResultsRouter(viewController: viewController)
            let worker = PrepareResultsWorker(preparation, canDelete: canDelete)
            let presenter = PrepareResultsPresenter(viewController: viewController)
            let interactor = PrepareResultInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
            worker.delegate = viewController
        }
    }

    /// On The Go
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
