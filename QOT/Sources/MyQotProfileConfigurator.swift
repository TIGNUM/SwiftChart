//
//  MyQotConfigurator.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotProfileConfigurator: AppStateAccess {

    static func configure(delegate: CoachCollectionViewControllerDelegate?, viewController: MyQotProfileViewController) {
        let router = MyQotProfileRouter(viewController: viewController)
        let worker = MyQotProfileWorker(userService: qot_dal.UserService.main, contentService: qot_dal.ContentService.main)
        let presenter = MyQotProfilePresenter(viewController: viewController)
        let interactor = MyQotProfileInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
        viewController.delegate = delegate
    }
}
