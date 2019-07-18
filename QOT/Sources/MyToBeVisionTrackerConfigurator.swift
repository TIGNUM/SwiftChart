//
//  MyToBeVisionTrackerConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 04.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyToBeVisionTrackerConfigurator: AppStateAccess {

    static func configure(viewController: MyToBeVisionTrackerViewController, controllerType: MyToBeVisionTrackerWorker.ControllerType) {
        let worker = MyToBeVisionTrackerWorker(userService: qot_dal.UserService.main, contentService: qot_dal.ContentService.main, controllerType: controllerType)
        let presenter = MyToBeVisionTrackerPresenter(viewController: viewController)
        let interactor = MyToBeVisionTrackerInteractor(worker: worker, presenter: presenter)
        viewController.interactor = interactor
    }
}
