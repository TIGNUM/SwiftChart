//
//  DailyCheckinStartConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 12.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class DailyCheckinStartConfigurator {

    static func configure(viewController: DailyCheckinStartViewController) {
        let router = DailyCheckinStartRouter(viewController: viewController)
        let worker = DailyCheckinStartWorker(questionService: qot_dal.QuestionService.main,
                                             healthService: qot_dal.HealthService.main)
        let presenter = DailyCheckinStartPresenter(viewController: viewController)
        let interactor = DailyCheckinStartInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
