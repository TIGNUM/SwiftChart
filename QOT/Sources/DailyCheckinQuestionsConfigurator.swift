//
//  DailyCheckinQuestionsConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 16.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class DailyCheckinQuestionsConfigurator {

    static func configure(viewController: DailyCheckinQuestionsViewController) {
        let router = DailyCheckinQuestionsRouter(viewController: viewController)
        let worker = DailyCheckinQuestionsWorker()
        let presenter = DailyCheckinQuestionsPresenter(viewController: viewController)
        let interactor = DailyCheckinQuestionsInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
