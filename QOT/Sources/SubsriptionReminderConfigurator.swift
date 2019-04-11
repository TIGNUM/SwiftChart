//
//  SubsriptionReminderConfigurator.swift
//  QOT
//
//  Created by karmic on 28.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class SubsriptionReminderConfigurator: AppStateAccess {

    static func make(isExpired: Bool) -> (SubsriptionReminderViewController) -> Void {
        return { (viewController) in
            let router = SubsriptionReminderRouter(windowManager: appState.windowManager, viewController: viewController)
            let worker = SubsriptionReminderWorker(services: appState.services, isExpired: isExpired)
            let presenter = SubsriptionReminderPresenter(viewController: viewController)
            let interactor = SubsriptionReminderInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
