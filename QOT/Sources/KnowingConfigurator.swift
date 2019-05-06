//
//  KnowingConfigurator.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class KnowingConfigurator {
    static func configure(delegate: CoachPageViewControllerDelegate?,
                          services: Services?,
                          viewController: KnowingViewController) {
        let router = KnowingRouter(viewController: viewController)
        let worker = KnowingWorker(services: services)
        let presenter = KnowingPresenter(viewController: viewController)
        let interactor = KnowingInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
        viewController.delegate = delegate
    }
}
