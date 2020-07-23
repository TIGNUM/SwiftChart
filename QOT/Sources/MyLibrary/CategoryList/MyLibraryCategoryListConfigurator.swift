//
//  MyLibraryCategoryListConfigurator.swift
//  QOT
//
//  Created by Sanggeon Park on 06.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyLibraryCategoryListConfigurator {

    static func make(with team: QDMTeam?, _ category: String? = nil) -> (MyLibraryCategoryListViewController) -> Void {
        return { (viewController) in
            let router = MyLibraryCategoryListRouter(viewController: viewController)
            let worker = MyLibraryCategoryListWorker()
            let presenter = MyLibraryCategoryListPresenter(viewController: viewController)
            let interactor = MyLibraryCategoryListInteractor(team: team, category: category,
                                                             worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
