//
//  ResultsPrepareConfigurator.swift
//  QOT
//
//  Created by karmic on 11.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class ResultsPrepareConfigurator {
    static func make(_ preparation: QDMUserPreparation?,
                     resultType: ResultType) -> (ResultsPrepareViewController) -> Void {
        return { (viewController) in
            let presenter = ResultsPreparePresenter(viewController: viewController)
            let interactor = ResultsPrepareInteractor(presenter: presenter, preparation, resultType: resultType)
            viewController.interactor = interactor
        }
    }

//    static func make(_ preparation: QDMUserPreparation?,
//                     resultType: ResultType) -> (PrepareResultsViewController) -> Void {
//        return { (viewController) in
//            let router = PrepareResultsRouter(viewController: viewController)
//            let worker = PrepareResultsWorker(preparation, resultType: resultType)
//            let presenter = PrepareResultsPresenter(viewController: viewController)
//            let interactor = PrepareResultInteractor(worker: worker, presenter: presenter, router: router)
//            viewController.interactor = interactor
//            worker.delegate = viewController
//        }
//    }
//
//    /// On The Go
//    static func configurate(_ contentId: Int) -> (PrepareResultsViewController) -> Void {
//        return { (viewController) in
//            let router = PrepareResultsRouter(viewController: viewController)
//            let worker = PrepareResultsWorker(contentId)
//            let presenter = PrepareResultsPresenter(viewController: viewController)
//            let interactor = PrepareResultInteractor(worker: worker, presenter: presenter, router: router)
//            viewController.interactor = interactor
//            worker.delegate = viewController
//        }
//    }
}
