//
//  TutorialConfigurator.swift
//  QOT
//
//  Created by karmic on 16.11.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

final class TutorialConfigurator {

    static func make() -> (TutorialViewController) -> Void {
        return { (viewController) in
            let router = TutorialRouter(viewController: viewController)
            let worker = TutorialWorker()
            let presenter = TutorialPresenter(viewController: viewController)
            let interactor = TutorialInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
