//
//  BaseRouter.swift
//  QOT
//
//  Created by karmic on 12.12.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import MessageUI
import qot_dal

protocol BaseRouterInterface {
    func presentMailComposer(recipients: [String], subject: String)
    func presentContent(_ contentId: Int)
    func presentContentItem(with id: Int)
    func presentMindsetShifter()
    func presentRecovery()

    func playMediaItem(_ contentItemId: Int)

    func showHomeScreen()
    func showFAQScreen(category: ContentCategory)
    func showCoachMarks()
    func showAlert(type: AlertType, handler: (() -> Void)?, handlerDestructive: (() -> Void)?)
    func showViewController(viewController: UIViewController, completion: (() -> Void)?)

    func showTBV()
    func showTeamTBV(_ team: QDMTeam, _ poll: QDMTeamToBeVisionPoll?)
    func showTeamTBVPollEXplanation(_ team: QDMTeam, _ poll: QDMTeamToBeVisionPoll?)
    func showTeamRatingExplanation(_ team: QDMTeam)

    func showTracker()
    func showTBVData(shouldShowNullState: Bool, visionId: Int?)
    func showRateScreen(with id: Int, delegate: TBVRateDelegate?)
    func showTBVGenerator()
    func showEditVision(title: String, vision: String, isFromNullState: Bool, team: QDMTeam?)

    func dismiss()
    func dismissChatBotFlow()

    func showTeamTBVGenerator(poll: QDMTeamToBeVisionPoll?)
    func showTeamTBVOptions(poll: QDMTeamToBeVisionPoll?, type: TeamToBeVisionOptionsModel.Types, remainingDays: Int)
}

class BaseRouter: BaseRouterInterface {
    // MARK: - Properties
    weak var viewController: UIViewController?

    // MARK: - Init
    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - BaseRouterInterface
    @objc func dismiss() {
        viewController?.dismiss(animated: true)
    }

    func dismissChatBotFlow() {
        AppDelegate.current.launchHandler.dismissChatBotFlow()
    }

    func presentContent(_ contentId: Int) {
        AppDelegate.current.launchHandler.showContentCollection(contentId)
    }

    func presentContentItem(with id: Int) {
        AppDelegate.current.launchHandler.showContentItem(id)
    }

    func presentMindsetShifter() {
        let configurator = DTMindsetConfigurator.make()
        let controller = DTMindsetViewController(configure: configurator)
        present(controller)
    }

    func presentRecovery() {
        let configurator = DTRecoveryConfigurator.make()
        let controller = DTRecoveryViewController(configure: configurator)
        present(controller)
    }

    func playMediaItem(_ contentItemId: Int) {
        AppDelegate.current.launchHandler.showContentItem(contentItemId)
    }

    func showHomeScreen() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.appCoordinator.showApp()
        }
    }

    func showFAQScreen(category: ContentCategory) {
        if let controller = R.storyboard.myQot.myQotSupportDetailsViewController() {
            MyQotSupportDetailsConfigurator.configure(viewController: controller, category: category)
            present(controller)
        }
    }

    func showCoachMarks() {
        if let controller = R.storyboard.coachMark.coachMarksViewController() {
            let configurator = CoachMarksConfigurator.make()
            configurator(controller)
            push(controller)
        }
    }

    func showTBV() {
        if let controller = R.storyboard.myToBeVision.myVisionViewController() {
            MyVisionConfigurator.configure(viewController: controller)
            push(controller)
        }
    }

    func showTeamTBV(_ team: QDMTeam, _ poll: QDMTeamToBeVisionPoll?) {
        if let controller = R.storyboard.myToBeVision.teamToBeVisionViewController() {
            let configurator = TeamToBeVisionConfigurator.make(team: team, poll: poll)
            configurator(controller)
            viewController?.show(controller, sender: nil)
        }
    }

    func presentMailComposer(recipients: [String], subject: String) {
        if MFMailComposeViewController.canSendMail() == true {
            let composer = MFMailComposeViewController()
            composer.setToRecipients(recipients)
            composer.setSubject(subject)
            composer.mailComposeDelegate = viewController
            present(composer)
        } else {
            viewController?.showAlert(type: .message(AppTextService.get(.generic_alert_no_email_body)))
        }
    }

    func showAlert(type: AlertType, handler: (() -> Void)?, handlerDestructive: (() -> Void)?) {
        viewController?.showAlert(type: type, handler: handler, handlerDestructive: handlerDestructive)
    }

    func showViewController(viewController: UIViewController, completion: (() -> Void)?) {
        present(viewController, completion: completion)
    }

    func showTeamTBVPollEXplanation(_ team: QDMTeam, _ poll: QDMTeamToBeVisionPoll?) {
        let type: Explanation.Types = team.thisUserIsOwner ? .tbvPollOwner : .tbvPollUser
        showExplanation(team, poll, type)
    }

    func showTeamRatingExplanation(_ team: QDMTeam) {
        let type: Explanation.Types = team.thisUserIsOwner ? .ratingOwner : .ratingUser
        showExplanation(team, nil, type)
    }

    func showTracker() {
        presentRateHistory(.tracker)
    }

    func showTBVData(shouldShowNullState: Bool, visionId: Int?) {
        if shouldShowNullState {
            guard let viewController = R.storyboard.myToBeVisionRate.tbvRateHistoryNullStateViewController() else { return }
            viewController.delegate = self.viewController as? MyVisionViewController
            viewController.visionId = visionId
            present(viewController)
        } else {
            presentRateHistory(.data)
        }
    }

    func showEditVision(title: String, vision: String, isFromNullState: Bool, team: QDMTeam?) {
        guard
            let controller = R.storyboard.myToBeVision.myVisionEditDetailsViewController(),
            let visionController = self.viewController else { return }
        MyVisionEditDetailsConfigurator.configure(viewController: controller,
                                                  title: title,
                                                  vision: vision,
                                                  isFromNullState: isFromNullState,
                                                  team: team)
        visionController.present(controller, animated: true)
    }

    func showRateScreen(with id: Int, delegate: TBVRateDelegate?) {
        if let viewController = R.storyboard.myToBeVisionRate.myToBeVisionRateViewController() {
            MyToBeVisionRateConfigurator.configure(viewController: viewController,
                                                   delegate: delegate,
                                                   visionId: id)
            present(viewController)
        }
    }

    func showTeamTBVGenerator(poll: QDMTeamToBeVisionPoll?) {
        let configurator = DTTeamTBVConfigurator.make(poll: poll)
        let controller = DTTeamTBVViewController(configure: configurator)
        present(controller)
    }

    func showTBVGenerator() {
        let configurator = DTTBVConfigurator.make(delegate: viewController as? MyVisionViewController)
        let controller = DTTBVViewController(configure: configurator)
        present(controller)
    }

    func showTeamTBVOptions(poll: QDMTeamToBeVisionPoll?, type: TeamToBeVisionOptionsModel.Types, remainingDays: Int) {
        if let viewController = R.storyboard.teamToBeVisionOptions.teamToBeVisionOptionsViewController() {
            TeamToBeVisionOptionsConfigurator.make(viewController: viewController,
                                                   type: type,
                                                   poll: poll,
                                                   remainingDays: remainingDays)
            push(viewController)
        }
    }
}

// MARK: - Private
private extension BaseRouter {
    func showExplanation(_ team: QDMTeam,
                         _ poll: QDMTeamToBeVisionPoll?,
                         _ type: Explanation.Types) {
        let controller = R.storyboard.visionRatingExplanation.visionRatingExplanationViewController()
        if let controller = controller {
            let configurator = VisionRatingExplanationConfigurator.make(team: team,
                                                                        poll: poll,
                                                                        type: type)
            configurator(controller)
            present(controller)
        }
    }

    func presentRateHistory(_ displayType: TBVGraph.DisplayType) {
        guard let viewController = R.storyboard.myToBeVisionRate.myToBeVisionTrackerViewController() else { return }
        TBVRateHistoryConfigurator.configure(viewController: viewController, displayType: displayType)
        present(viewController)
    }

    func push(_ childViewController: UIViewController) {
        viewController?.pushToStart(childViewController: childViewController)
    }

    func present(_ controller: UIViewController, completion: (() -> Void)? = nil) {
        viewController?.present(controller, animated: true, completion: completion)
    }
}
