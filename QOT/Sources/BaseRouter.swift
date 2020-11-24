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
    func showTeamTBVPollEXplanation(_ team: QDMTeam)
    func showTeamRatingExplanation(_ team: QDMTeam)

    func showTracker(for team: QDMTeam?)
    func showTBVData(shouldShowNullState: Bool, visionId: Int?)
    func showRateScreen(with id: Int, delegate: TBVRateDelegate?)
    func showEditVision(title: String, vision: String, isFromNullState: Bool, team: QDMTeam?)
    func presentEditTeam(_ type: TeamEdit.View, team: QDMTeam?)
    func dismiss()
    func dismissChatBotFlow()

    func showTeamTBVGenerator(poll: QDMTeamToBeVisionPoll?, team: QDMTeam, showBanner: Bool?) 
    func showTeamAdmin(type: TeamAdmin.Types, team: QDMTeam?, notificationSent: Bool?)
    func showExplanation(_ team: QDMTeam?, _ type: Explanation.Types)

    func showRateScreen(trackerPoll: QDMTeamToBeVisionTrackerPoll?,
                        team: QDMTeam?,
                        showBanner: Bool?,
                        delegate: TBVRateDelegate?)
    func showBanner(message: String)
}

class BaseRouter: BaseRouterInterface {

    // MARK: - Properties
    weak var viewController: UIViewController?

    // MARK: - Init
    init(viewController: UIViewController?) {
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
            let configurator = TeamToBeVisionConfigurator.make(team: team)
            configurator(controller)
            viewController?.show(controller, sender: nil)
        }
    }

    func presentEditTeam(_ type: TeamEdit.View, team: QDMTeam?) {
        let showClosure: (UIViewController?) -> Void = { (presentingViewController) in
            let identifier = R.storyboard.team.teamEditViewControllerID.identifier
            let controller = R.storyboard.team().instantiateViewController(withIdentifier: identifier) as? TeamEditViewController
            if let controller = controller {
                let configurator = TeamEditConfigurator.make(type: type, team: team)
                configurator(controller)
                presentingViewController?.present(controller, animated: true)
            }
        }
        if let presentingViewController = viewController?.presentingViewController {
            viewController?.dismiss(animated: true, completion: {
                showClosure(presentingViewController)
            })
        } else {
            showClosure(viewController)
        }
    }

    func presentMailComposer(recipients: [String], subject: String) {
        BaseRouter.sendEmail(to: recipients.first ?? Defaults.firstLevelSupportEmail,
                             subject: subject,
                             body: "", from: viewController)
    }

    static func sendEmail(to: String, subject: String, body: String, from: UIViewController?) {
        if MFMailComposeViewController.canSendMail() {
            let composer = MFMailComposeViewController()
            composer.setToRecipients([to])
            composer.setSubject(subject)
            composer.mailComposeDelegate = from
            from?.present(composer, animated: true)
            return
        }
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            UIApplication.shared.open(gmailUrl, options: [:], completionHandler: nil)
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            UIApplication.shared.open(outlookUrl, options: [:], completionHandler: nil)
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            UIApplication.shared.open(yahooMail, options: [:], completionHandler: nil)
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            UIApplication.shared.open(sparkUrl, options: [:], completionHandler: nil)
        } else if let defaultUrl = defaultUrl, UIApplication.shared.canOpenURL(defaultUrl) {
            UIApplication.shared.open(defaultUrl, options: [:], completionHandler: nil)
        } else {
            from?.showAlert(type: .message(AppTextService.get(.generic_alert_no_email_body)))
        }
    }

    func showTracker(for team: QDMTeam?) {
        presentRateHistory(for: team, .tracker)
    }

    func showAlert(type: AlertType, handler: (() -> Void)?, handlerDestructive: (() -> Void)?) {
        viewController?.showAlert(type: type, handler: handler, handlerDestructive: handlerDestructive)
    }

    func showViewController(viewController: UIViewController, completion: (() -> Void)?) {
        present(viewController, completion: completion)
    }

    func showTeamTBVPollEXplanation(_ team: QDMTeam) {
        let type: Explanation.Types = team.thisUserIsOwner ? .tbvPollOwner : .tbvPollUser
        showExplanation(team, type)
    }

    func showTeamRatingExplanation(_ team: QDMTeam) {
        let type: Explanation.Types = team.thisUserIsOwner ? .ratingOwner : .ratingUser
        showExplanation(team, type)
    }

    func showTBVData(shouldShowNullState: Bool, visionId: Int?) {
        if shouldShowNullState {
            guard let viewController = R.storyboard.myToBeVisionRate.tbvRateHistoryNullStateViewController() else { return }
            viewController.delegate = self.viewController as? MyVisionViewController
            viewController.visionId = visionId
            present(viewController)
        } else {
            presentRateHistory(for: nil, .data)
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

    func showRateScreen(trackerPoll: QDMTeamToBeVisionTrackerPoll?,
                        team: QDMTeam?,
                        showBanner: Bool?,
                        delegate: TBVRateDelegate?) {
        let showClosure: (UIViewController?) -> Void = { (presentingViewController) in
            if let controller = R.storyboard.myToBeVisionRate.myToBeVisionRateViewController() {
                MyToBeVisionRateConfigurator.configure(controller: controller,
                                                       trackerPoll: trackerPoll,
                                                       team: team,
                                                       showBanner: showBanner)
                controller.delegate = delegate
                presentingViewController?.present(controller, animated: true, completion: nil)
            }
        }
        if let presentingViewController = viewController?.presentingViewController {
            viewController?.dismiss(animated: true, completion: {
                showClosure(presentingViewController)
            })
        } else {
            showClosure(viewController)
        }
    }

    func showRateScreen(with id: Int, delegate: TBVRateDelegate?) {
        if let controller = R.storyboard.myToBeVisionRate.myToBeVisionRateViewController() {
            MyToBeVisionRateConfigurator.configure(controller: controller, visionId: id, showBanner: nil)
            controller.delegate = delegate
            present(controller)
        }
    }

    func showTeamTBVGenerator(poll: QDMTeamToBeVisionPoll?, team: QDMTeam, showBanner: Bool?) {
        let configurator = DTTeamTBVConfigurator.make(poll: poll, team: team, showBanner: showBanner)
        let controller = DTTeamTBVViewController(configure: configurator)
        present(controller)
    }

    func showTBVGenerator() {
        let configurator = DTTBVConfigurator.make(delegate: viewController as? MyVisionViewController)
        let controller = DTTBVViewController(configure: configurator)
        present(controller)
    }

    func showTeamAdmin(type: TeamAdmin.Types, team: QDMTeam?, notificationSent: Bool?) {
        if let vc = R.storyboard.teamToBeVisionOptions.teamToBeVisionOptionsViewController() {
            TeamToBeVisionOptionsConfigurator.make(viewController: vc,
                                                   type: type,
                                                   team: team,
                                                   notificationSent: notificationSent)
            self.viewController?.show(vc, sender: nil)
        }
    }

    func showBanner(message: String) {
        if let view = viewController?.view {
            let banner = NotificationBanner.shared
            banner.configure(message: message, isDark: false)
            banner.show(in: view)
        }
    }

    func showExplanation(_ team: QDMTeam?, _ type: Explanation.Types) {
        if let controller = R.storyboard.visionRatingExplanation.visionRatingExplanationViewController() {
            VisionRatingExplanationConfigurator.make(team: team, type: type)(controller)
            present(controller)
        }
    }
}

// MARK: - Private
private extension BaseRouter {

    func presentRateHistory(for team: QDMTeam?, _ displayType: TBVGraph.DisplayType) {
        guard let controller = R.storyboard.myToBeVisionRate.myToBeVisionTrackerViewController() else { return }
        TBVRateHistoryConfigurator.configure(viewController: controller,
                                             displayType: displayType,
                                             team: team)
        present(controller)
    }

    func push(_ childViewController: UIViewController) {
        viewController?.pushToStart(childViewController: childViewController)
    }

    func present(_ controller: UIViewController, completion: (() -> Void)? = nil) {
        viewController?.present(controller, animated: true, completion: completion)
    }
}
