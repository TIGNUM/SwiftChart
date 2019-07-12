//
//  MyQotSiriShortcutsConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotSiriShortcutsConfigurator: AppStateAccess {
    static func configure(viewController: MyQotSiriShortcutsViewController) {
        let router =  MyQotSiriShortcutsRouter(viewController: viewController)
        let worker = MyQotSiriShortcutsWorker(contentService: qot_dal.ContentService.main)
        let presenter = MyQotSiriShortcutsPresenter(viewController: viewController)
        let interactor = MyQotSiriShortcutsInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
