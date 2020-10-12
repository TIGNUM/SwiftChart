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
    static func configure(viewController: MyToBeVisionRateViewController,
                          delegate: TBVRateDelegate?,
                          visionId: Int,
                          team: QDMTeam?) {
        let router = MyToBeVisionRateRouter(viewController: viewController)
//<<<<<<< HEAD
        let worker = MyToBeVisionRateWorker(visionId: visionId, team: team)
//=======
//        let worker = MyToBeVisionRateWorker(visionId: visionId, viewController: viewController, team: nil)
//>>>>>>> f9d253774380beb2d9f3f07c2319adab215eeb4b
        let presenter = MyToBeVisionRatePresenter(viewController: viewController)
        let interactor = MyToBeVisionRateInteractor(presenter: presenter,
                                                    worker: worker,
                                                    router: router,
                                                    isoDate: Date())
        viewController.interactor = interactor
        viewController.delegate = delegate
    }
//<<<<<<< HEAD
//=======
//
//    static func configure(previousController: VisionRatingExplanationViewController,
//                          viewController: MyToBeVisionRateViewController,
//                          visionId: Int,
//                          team: QDMTeam?) {
//        let router = MyToBeVisionRateRouter(viewController: viewController)
//        let worker = MyToBeVisionRateWorker(visionId: visionId, viewController: viewController, team: team)
//        let presenter = MyToBeVisionRatePresenter(viewController: viewController)
//        let interactor = MyToBeVisionRateInteractor(presenter: presenter,
//                                                    worker: worker,
//                                                    router: router,
//                                                    isoDate: Date())
//        viewController.interactor = interactor
//        viewController.delegate = previousController
//    }
//
//    static func configure(previousController: TeamToBeVisionOptionsViewController,
//                          viewController: MyToBeVisionRateViewController,
//                          visionId: Int,
//                          team: QDMTeam?) {
//        let router = MyToBeVisionRateRouter(viewController: viewController)
//        let worker = MyToBeVisionRateWorker(visionId: visionId, viewController: viewController, team: team)
//        let presenter = MyToBeVisionRatePresenter(viewController: viewController)
//        let interactor = MyToBeVisionRateInteractor(presenter: presenter,
//                                                    worker: worker,
//                                                    router: router,
//                                                    isoDate: Date())
//        viewController.interactor = interactor
//        viewController.delegate = previousController
//    }
//>>>>>>> f9d253774380beb2d9f3f07c2319adab215eeb4b
}
