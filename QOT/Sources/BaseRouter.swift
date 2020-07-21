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

    func dismiss()
    func dismissChatBotFlow()
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
        viewController?.present(controller, animated: true)
    }

    func presentRecovery() {
        let configurator = DTRecoveryConfigurator.make()
        let controller = DTRecoveryViewController(configure: configurator)
        viewController?.present(controller, animated: true)
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
            viewController?.present(controller, animated: true)
        }
    }

    func showCoachMarks() {
        if let controller = R.storyboard.coachMark.coachMarksViewController() {
            let configurator = CoachMarksConfigurator.make()
            configurator(controller)
            viewController?.pushToStart(childViewController: controller)
        }
    }

    func showTBV(team: QDMTeam?) {
        guard let team = team else {
            if let controller = R.storyboard.myToBeVision.myVisionViewController() {
                     MyVisionConfigurator.configure(viewController: controller, team: nil)
                     viewController?.pushToStart(childViewController: controller)
            }
            return
        }
        let controller = R.storyboard.myToBeVision.teamToBeVisionViewController()
        if let controller = controller {
            let configurator = TeamToBeVisionConfigurator.make(team: team)
            configurator(controller)
            viewController?.show(controller, sender: nil)
        }
    }

//    func showTBV() {
//           if let controller = R.storyboard.myToBeVision.myVisionViewController() {
//               MyVisionConfigurator.configure(viewController: controller)
//               viewController?.pushToStart(childViewController: controller)
//           }
//    }

    func presentMailComposer(recipients: [String], subject: String) {
        if MFMailComposeViewController.canSendMail() == true {
            let composer = MFMailComposeViewController()
            composer.setToRecipients(recipients)
            composer.setSubject(subject)
            composer.mailComposeDelegate = viewController
            viewController?.present(composer, animated: true)
        } else {
            viewController?.showAlert(type: .message(AppTextService.get(.generic_alert_no_email_body)))
        }
    }
}
