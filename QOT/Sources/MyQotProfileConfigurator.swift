//
//  MyQotConfigurator.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotProfileConfigurator: AppStateAccess {

    static func configure(delegate: CoachCollectionViewControllerDelegate?, viewController: MyQotProfileViewController) {
        let router = MyQotProfileRouter(viewController: viewController)
        let worker = MyQotProfileWorker(services: appState.services, syncManager: appState.appCoordinator.syncManager)
        let presenter = MyQotProfilePresenter(viewController: viewController)
        let interactor = MyQotProfileInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
        viewController.delegate = delegate
    }
}
