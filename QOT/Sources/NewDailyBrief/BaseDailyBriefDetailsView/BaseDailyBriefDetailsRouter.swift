//
//  BaseDailyBriefDetailsRouter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 09/11/2020.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class BaseDailyBriefDetailsRouter: BaseRouter {

    // MARK: - Properties
    private weak var dailyBriefDetailsViewController: BaseDailyBriefDetailsViewController?

    // MARK: - Init
    init(viewController: BaseDailyBriefDetailsViewController?) {
        super.init(viewController: viewController)
        self.dailyBriefDetailsViewController = viewController
    }
}

// MARK: - BaseDailyBriefDetailsRouterInterface
extension BaseDailyBriefDetailsRouter: BaseDailyBriefDetailsRouterInterface {
    func showMyDataScreen() {
        if let childViewController = R.storyboard.myDataScreen.myDataScreenViewControllerID() {
            let configurator = MyDataScreenConfigurator.make()
            configurator(childViewController)
            childViewController.showStatusBar = false
            dailyBriefDetailsViewController?.navigationController?.pushViewController(childViewController, animated: true)
        }
    }

    func presentCustomizeTarget(_ data: RatingQuestionViewModel.Question?) {
        guard let data = data,
            let controller = QuestionnaireViewController.viewController(with: data,
                                                                        delegate: dailyBriefDetailsViewController,
                                                                        controllerType: .customize) else {
            return
        }
        dailyBriefDetailsViewController?.pushToStart(childViewController: controller)
    }

    func showTBV() {
        if let controller = R.storyboard.myToBeVision.myVisionViewController() {
            MyVisionConfigurator.configure(viewController: controller, showSubVCModal: false)
            dailyBriefDetailsViewController?.pushToStart(childViewController: controller)
        }
    }

    func presentMindsetResults(for mindsetShifter: QDMMindsetShifter?) {
         let configurator = ShifterResultConfigurator.make(mindsetShifter: mindsetShifter,
                                                           resultType: .mindsetShifterBucket)
         let controller = ShifterResultViewController(configure: configurator)
        dailyBriefDetailsViewController?.present(controller, animated: true)
     }

    func presentPrepareResults(for preparation: QDMUserPreparation?) {
        if let preparation = preparation {
            let configurator = ResultsPrepareConfigurator.make(preparation, resultType: .prepareDailyBrief)
            let controller = ResultsPrepareViewController(configure: configurator)
            dailyBriefDetailsViewController?.present(controller, animated: true)
        }
    }
}
