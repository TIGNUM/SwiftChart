//
//  DailyBriefRouter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DailyBriefRouter: BaseRouter {

    // MARK: - Properties
    private weak var dailyBriefViewController: DailyBriefViewController?

    // MARK: - Init
    init(viewController: DailyBriefViewController) {
        super.init(viewController: viewController)
        self.dailyBriefViewController = viewController
    }
}

// MARK: - DailyBriefRouterInterface
extension DailyBriefRouter: DailyBriefRouterInterface {
    func presentPopUp(copyrightURL: String?, description: String?) {
        let popUpController = PopUpCopyrightViewController(delegate: dailyBriefViewController,
                                                           copyrightURL: copyrightURL,
                                                           description: description)
        popUpController.modalPresentationStyle = .overCurrentContext
        viewController?.present(popUpController, animated: true)
    }

    func presentSolveResults(solve: QDMSolve) {
        let configurator = SolveResultsConfigurator.make(from: solve, resultType: .solveDailyBrief)
        let solveResultsController = SolveResultsViewController(configure: configurator)
        viewController?.present(solveResultsController, animated: true)
    }

    func presentDailyCheckInQuestions() {
        if let newController = R.storyboard.dailyCheckin.dailyCheckinQuestionsViewController() {
            DailyCheckinQuestionsConfigurator.configure(viewController: newController)
            let navigationController = UINavigationController(rootViewController: newController)
            navigationController.isNavigationBarHidden = true
            viewController?.present(navigationController, animated: true)
        }
    }

    func presentCoachPreparation() {
        if let launchURL = URLScheme.prepareEvent.launchURLWithParameterValue("") {
            AppDelegate.current.launchHandler.process(url: launchURL)
        }
    }

    func presentPrepareResults(for preparation: QDMUserPreparation?) {
        if let preparation = preparation {
            let configurator = ResultsPrepareConfigurator.make(preparation, resultType: .prepareDailyBrief)
            let controller = ResultsPrepareViewController(configure: configurator)
            viewController?.present(controller, animated: true)
        }
    }

     func presentMindsetResults(_ mindsetShifter: QDMMindsetShifter?) {
          let configurator = ShifterResultConfigurator.make(mindsetShifter: mindsetShifter,
                                                            resultType: .mindsetShifterBucket)
          let controller = ShifterResultViewController(configure: configurator)
          viewController?.present(controller, animated: true)
      }

    func presentTeamPendingInvites() {
        if let launchURL = URLScheme.teamInvitations.launchURLWithParameterValue("") {
            AppDelegate.current.launchHandler.process(url: launchURL)
        }
    }

    func showExplanation(_ team: QDMTeam, type: Explanation.Types) {
        let controller = R.storyboard.visionRatingExplanation.visionRatingExplanationViewController()
        if let controller = controller {
            let configurator = VisionRatingExplanationConfigurator.make(team: team,
                                                                        type: type)
            configurator(controller)
            viewController?.present(controller, animated: true)
        }
    }

    func presentDailyBriefDetailsScreen(model: BaseDailyBriefViewModel,
                                        transitioningDelegate: UIViewControllerTransitioningDelegate?) {
        if let controller = R.storyboard.main.baseDailyBriefDetailsViewController() {
            BaseDailyBriefDetailsConfigurator.configure(model: model, viewController: controller)
            dailyBriefViewController?.interactor.setDetailsDelegate(controller)
            controller.modalPresentationCapturesStatusBarAppearance = true
            controller.modalPresentationStyle = .custom
            controller.transitioningDelegate = transitioningDelegate
            dailyBriefViewController?.present(controller, animated: true, completion: nil)
        }
    }
}
