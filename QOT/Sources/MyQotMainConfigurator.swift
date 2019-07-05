//
//  MyQotMainConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotMainConfigurator {
    static func configure(delegate: CoachCollectionViewControllerDelegate,
                          services: Services,
                          viewController: MyQotMainViewController) {
        let router = MyQotMainRouter(viewController: viewController, services: services, delegate: delegate)
        let worker = MyQotMainWorker(services: services)
        let presenter = MyQotMainPresenter(viewController: viewController)
        let interactor = MyQotMainInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
        viewController.delegate = delegate
    }
}
