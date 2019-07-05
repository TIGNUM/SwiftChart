//
//  MyPrepsConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.

import Foundation

final class MyPrepsConfigurator {
    static func configure(viewController: MyPrepsViewController, delegate: CoachCollectionViewControllerDelegate?) {
        let router = MyPrepsRouter(viewController: viewController)
        let worker = MyPrepsWorker()
        let presenter = MyPrepsPresenter(viewController: viewController)
        let interactor = MyPrepsInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
        viewController.delegate = delegate
    }
}
