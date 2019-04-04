//
//  LevelThreeConfigurator.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class LevelThreeConfigurator {

    static func make() -> (LevelThreeViewController) -> Void {
        return { (viewController) in
            let router = LevelThreeRouter(viewController: viewController)
            let worker = LevelThreeWorker()
            let presenter = LevelThreePresenter(viewController: viewController)
            let interactor = LevelThreeInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
