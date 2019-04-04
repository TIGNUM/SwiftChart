//
//  DailyBriefConfigurator.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class DailyBriefConfigurator {

    static func make(delegate: CoachPageViewControllerDelegate?,
                     services: Services?) -> (DailyBriefViewController) -> Void {
        return { (viewController) in
            let router = DailyBriefRouter(viewController: viewController)
            let worker = DailyBriefWorker(services: services)
            let presenter = DailyBriefPresenter(viewController: viewController)
            let interactor = DailyBriefInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
            viewController.delegate = delegate
        }
    }
}
