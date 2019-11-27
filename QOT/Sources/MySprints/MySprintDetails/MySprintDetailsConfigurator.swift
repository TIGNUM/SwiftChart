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

    static func make(sprintId: String) -> (MySprintDetailsViewController) -> Void {
        return { (viewController) in
            let worker = MySprintDetailsWorker(sprintId: sprintId)
            let presenter = MySprintDetailsPresenter(viewController: viewController)
            let interactor = MySprintDetailsInteractor(worker: worker, presenter: presenter)
            viewController.interactor = interactor
        }
    }
}
