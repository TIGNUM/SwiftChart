//
//  MySprintDetailsConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MySprintDetailsConfigurator {

    static func make(sprintId: Int) -> (MySprintDetailsViewController) -> Void {
        return { (viewController) in
            let router = MySprintDetailsRouter(viewController: viewController)
            let worker = MySprintDetailsWorker(sprintId: sprintId)
            let presenter = MySprintDetailsPresenter(viewController: viewController)
            let interactor = MySprintDetailsInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
