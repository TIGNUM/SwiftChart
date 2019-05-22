//
//  StrategyListConfigurator.swift
//  QOT
//
//  Created by karmic on 15.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class StrategyListConfigurator: AppStateAccess {
    static func configure(viewController: StrategyListViewController,
                          selectedStrategyID: Int?,
                          delegate: CoachCollectionViewControllerDelegate?) {
        let router = StrategyListRouter(viewController: viewController)
        let worker = StrategyListWorker(services: appState.services,
                                        selectedStrategyID: selectedStrategyID)
        let presenter = StrategyListPresenter(viewController: viewController)
        let interactor = StrategyListInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
        viewController.delegate = delegate
    }
}
