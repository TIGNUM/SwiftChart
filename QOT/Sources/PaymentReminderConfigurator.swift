//
//  PaymentReminderConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class PaymentReminderConfigurator: AppStateAccess {

    static func make(isExpired: Bool) -> (PaymentReminderViewController) -> Void {
        return { (viewController) in
            let router = PaymentReminderRouter(windowManager: appState.windowManager, viewController: viewController)
            let worker = PaymentReminderWorker(services: appState.services, isExpired: isExpired)
            let presenter = PaymentReminderPresenter(viewController: viewController)
            let interactor = PaymentReminderInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
