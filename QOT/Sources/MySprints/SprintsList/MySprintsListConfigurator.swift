//
//  MySprintsListConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class MySprintsListConfigurator: AppStateAccess {

    static func make() -> (MySprintsListViewController) -> Void {
        return { (viewController) in
            let router = MySprintsListRouter(viewController: viewController)
            let worker = MySprintsListWorker()
            let presenter = MySprintsListPresenter(viewController: viewController)
            let interactor = MySprintsListInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
