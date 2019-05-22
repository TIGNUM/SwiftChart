//
//  MyQotConfigurator.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotConfigurator {

    static func configure(delegate: CoachCollectionViewControllerDelegate?, viewController: MyQotViewController) {
        let router = MyQotRouter(viewController: viewController)
        let worker = MyQotWorker()
        let presenter = MyQotPresenter(viewController: viewController)
        let interactor = MyQotInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
        viewController.delegate = delegate
    }
}
