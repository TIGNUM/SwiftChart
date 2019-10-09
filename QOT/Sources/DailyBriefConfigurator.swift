//
//  DailyBriefConfigurator.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class DailyBriefConfigurator {

    static func configure(delegate: CoachCollectionViewControllerDelegate?,
                          viewController: DailyBriefViewController) {
        let router = DailyBriefRouter(viewController: viewController)
        let worker = DailyBriefWorker(questionService: qot_dal.QuestionService.main,
                                      userService: qot_dal.UserService.main,
                                      contentService: qot_dal.ContentService.main,
                                      settingService: qot_dal.SettingService.main,
                                      healthService: qot_dal.HealthService.main)
        let presenter = DailyBriefPresenter(viewController: viewController)
        let interactor = DailyBriefInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
        viewController.delegate = delegate
    }
}
