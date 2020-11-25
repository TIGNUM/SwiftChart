//
//  MyToBeVisionRateConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyToBeVisionRateConfigurator {
    static func configure(controller: MyToBeVisionRateViewController, visionId: Int, showBanner: Bool?) {
        let worker = MyToBeVisionRateWorker(visionId: visionId)
        configure(controller: controller, worker: worker, showBanner: showBanner)
    }

    static func configure(controller: MyToBeVisionRateViewController,
                          trackerPoll: QDMTeamToBeVisionTrackerPoll?,
                          team: QDMTeam?,
                          showBanner: Bool?) {
        let worker = MyToBeVisionRateWorker(trackerPoll: trackerPoll, team: team)
        configure(controller: controller, worker: worker, showBanner: showBanner)
    }

    private static func configure(controller: MyToBeVisionRateViewController,
                                  worker: MyToBeVisionRateWorker,
                                  showBanner: Bool?) {
        let router = MyToBeVisionRateRouter(viewController: controller)
        let presenter = MyToBeVisionRatePresenter(viewController: controller)
        let interactor = MyToBeVisionRateInteractor(presenter: presenter,
                                                    worker: worker,
                                                    router: router,
                                                    showBanner: showBanner)
        controller.interactor = interactor
    }
}
