//
//  DecisionTreeConfigurator.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class DecisionTreeConfigurator {
    static func make(for type: DecisionTreeType) -> (DecisionTreeViewController) -> Void {
        return { (viewController) in
            let router = DecisionTreeRouter(viewController: viewController)
            let worker = DecisionTreeWorker(type: type)
            let presenter = DecisionTreePresenter(viewController: viewController)
            let interactor = DecisionTreeInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
            worker.interactor = interactor
            worker.fetchToBeVision() // if needed……
        }
    }
}
