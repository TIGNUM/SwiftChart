//
//  LevelTwoConfigurator.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class LevelTwoConfigurator {

    static func make(delegate: CoachCollectionViewControllerDelegate?) -> (LevelTwoViewController) -> Void {
        return { (viewController) in
            let router = LevelTwoRouter(viewController: viewController)
            let worker = LevelTwoWorker()
            let presenter = LevelTwoPresenter(viewController: viewController)
            let interactor = LevelTwoInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
