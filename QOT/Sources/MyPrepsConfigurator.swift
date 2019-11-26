//
//  MyPrepsConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.

import Foundation

final class MyPrepsConfigurator {
    static func configure(viewController: MyPrepsViewController, delegate: CoachCollectionViewControllerDelegate?) {
        let presenter = MyPrepsPresenter(viewController: viewController)
        let interactor = MyPrepsInteractor(presenter: presenter)
        viewController.interactor = interactor
        viewController.delegate = delegate
    }
}
