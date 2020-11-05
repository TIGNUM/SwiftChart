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
    static func configure(controller: MyToBeVisionRateViewController, visionId: Int) {
        let worker = MyToBeVisionRateWorker(visionId: visionId)
        configure(controller: controller, worker: worker)
    }

    static func configure(controller: MyToBeVisionRateViewController,
                          trackerPoll: QDMTeamToBeVisionTrackerPoll?,
                          team: QDMTeam?) {
        let worker = MyToBeVisionRateWorker(trackerPoll: trackerPoll, team: team)
        configure(controller: controller, worker: worker)
    }

    private static func configure(controller: MyToBeVisionRateViewController,
                                  worker: MyToBeVisionRateWorker) {
        let router = MyToBeVisionRateRouter(viewController: controller)
        let presenter = MyToBeVisionRatePresenter(viewController: controller)
        let interactor = MyToBeVisionRateInteractor(presenter: presenter,
                                                    worker: worker,
                                                    router: router)
        controller.interactor = interactor
    }
}
