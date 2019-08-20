//
//  CoachConfigurator.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class CoachConfigurator {

    static func make(viewController: CoachViewController?) {
        guard let viewController = viewController else { return }
        let router = CoachRouter(viewController: viewController)
        let worker = CoachWorker()
        let presenter = CoachPresenter(viewController: viewController)
        let interactor = CoachInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
