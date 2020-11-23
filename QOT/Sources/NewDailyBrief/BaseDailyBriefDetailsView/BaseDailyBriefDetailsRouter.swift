//
//  BaseDailyBriefDetailsRouter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 09/11/2020.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class BaseDailyBriefDetailsRouter {

    // MARK: - Properties
    private weak var viewController: BaseDailyBriefDetailsViewController?

    // MARK: - Init
    init(viewController: BaseDailyBriefDetailsViewController?) {
        self.viewController = viewController
    }
}

// MARK: - BaseDailyBriefDetailsRouterInterface
extension BaseDailyBriefDetailsRouter: BaseDailyBriefDetailsRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func showMyDataScreen() {
        if let childViewController = R.storyboard.myDataScreen.myDataScreenViewControllerID() {
            let configurator = MyDataScreenConfigurator.make()
            configurator(childViewController)
            childViewController.showStatusBar = false
            viewController?.navigationController?.pushViewController(childViewController, animated: true)
        }
    }

    func presentCustomizeTarget(_ data: RatingQuestionViewModel.Question?) {
        if let data = data,
            let controller = QuestionnaireViewController.viewController(with: data,
                                                                        delegate: viewController,
                                                                        controllerType: .customize) {
            viewController?.pushToStart(childViewController: controller)
        }
    }

    func showTBV() {
        if let controller = R.storyboard.myToBeVision.myVisionViewController() {
            MyVisionConfigurator.configure(viewController: controller, showSubVCModal: false)
            viewController?.pushToStart(childViewController: controller)
        }
    }

    func presentMindsetResults(for mindsetShifter: QDMMindsetShifter?) {
         let configurator = ShifterResultConfigurator.make(mindsetShifter: mindsetShifter,
                                                           resultType: .mindsetShifterBucket)
         let controller = ShifterResultViewController(configure: configurator)
         viewController?.present(controller, animated: true)
     }

    func presentPrepareResults(for preparation: QDMUserPreparation?) {
        if let preparation = preparation {
            let configurator = ResultsPrepareConfigurator.make(preparation, resultType: .prepareDailyBrief)
            let controller = ResultsPrepareViewController(configure: configurator)
            viewController?.present(controller, animated: true)
        }
    }
}
