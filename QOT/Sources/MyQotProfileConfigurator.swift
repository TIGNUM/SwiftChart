//
//  MyQotConfigurator.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotProfileConfigurator {

    static func configure(delegate: CoachCollectionViewControllerDelegate?, viewController: MyQotProfileViewController) {
        let router = MyQotProfileRouter(viewController: viewController)
        let worker = MyQotProfileWorker(userService: UserService.main, contentService: ContentService.main)
        let presenter = MyQotProfilePresenter(viewController: viewController)
        let interactor = MyQotProfileInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
        viewController.delegate = delegate
    }
}
