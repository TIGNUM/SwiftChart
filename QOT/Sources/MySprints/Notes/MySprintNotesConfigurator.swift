//
//  MySprintNotesConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 11/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MySprintNotesConfigurator {

    static func make() -> (MySprintNotesViewController, QDMSprint, MySprintDetailsItem.Action) -> Void {
        return { (viewController, sprint, action) in
            let router = MySprintNotesRouter(viewController: viewController)
            let worker = MySprintNotesWorker(sprint: sprint, action: action)
            let presenter = MySprintNotesPresenter(viewController: viewController)
            let interactor = MySprintNotesInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
