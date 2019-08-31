//
//  MyVisionEditDetailsConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyVisionEditDetailsConfigurator: AppStateAccess {
    static func configure(viewController: MyVisionEditDetailsViewController, title: String, vision: String, isFromNullState: Bool) {
        let wdigetManager = ExtensionsDataManager(services: appState.services)
        let worker = MyVisionEditDetailsWorker(title: title, vision: vision, widgetManager: wdigetManager, contentService: qot_dal.ContentService.main, isFromNullState: isFromNullState)
        let presenter = MyVisionEditDetailsPresenter(viewController: viewController)
        let interactor = MyVisionEditDetailsInteractor(presenter: presenter, worker: worker)
        viewController.interactor = interactor
    }
}
