//
//  MyLibraryCategoryListConfigurator.swift
//  QOT
//
//  Created by Sanggeon Park on 06.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class MyLibraryCategoryListConfigurator {

    static func make() -> (MyLibraryCategoryListViewController) -> Void {
        return { (viewController) in
            let router = MyLibraryCategoryListRouter(viewController: viewController)
            let worker = MyLibraryCategoryListWorker()
            let presenter = MyLibraryCategoryListPresenter(viewController: viewController)
            let interactor = MyLibraryCategoryListInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
