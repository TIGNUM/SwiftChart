//
//  MyVisionEditDetailsConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyVisionEditDetailsConfigurator {
    static func configure(viewController: MyVisionEditDetailsViewController, title: String, vision: String, isFromNullState: Bool, team: QDMTeam?) {
        let wdigetManager = ExtensionsDataManager()
        let worker = MyVisionEditDetailsWorker(title: title, vision: vision, widgetManager: wdigetManager, contentService: ContentService.main, isFromNullState: isFromNullState, team: team)
        let presenter = MyVisionEditDetailsPresenter(viewController: viewController)
        let interactor = MyVisionEditDetailsInteractor(presenter: presenter, worker: worker)
        viewController.interactor = interactor
    }
}
