//
//  SubsriptionReminderConfigurator.swift
//  QOT
//
//  Created by karmic on 28.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class SubsriptionReminderConfigurator {

    static func make(windowManager: WindowManager, isExpired: Bool) -> (SubsriptionReminderViewController) -> Void {
        return { (viewController) in
            let router = SubsriptionReminderRouter(windowManager: windowManager, viewController: viewController)
            let worker = SubsriptionReminderWorker(isExpired: isExpired)
            let presenter = SubsriptionReminderPresenter(viewController: viewController)
            let interactor = SubsriptionReminderInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
