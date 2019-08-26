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
                          viewController: MyQotMainViewController) {
        let router = MyQotMainRouter(viewController: viewController, delegate: delegate)
        let worker = MyQotMainWorker()
        let presenter = MyQotMainPresenter(viewController: viewController)
        let interactor = MyQotMainInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
        viewController.delegate = delegate
    }
}
