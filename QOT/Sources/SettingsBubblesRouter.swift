//
//  SettingsBubblesRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 12/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import MessageUI

final class SettingsBubblesRouter: NSObject {

    private let viewController: SettingsBubblesViewController
    private let services: Services

    init(viewController: SettingsBubblesViewController, services: Services) {
        self.viewController = viewController
        self.services = services
    }
}

// MARK: - SettingsBubblesRouter Interface

extension SettingsBubblesRouter: SettingsBubblesRouterInterface {

    func handleSelection(bubbleTapped: SettingsBubblesModel.SettingsBubblesItem) {
        switch bubbleTapped {
        case .benefits: presentContentItem(id: bubbleTapped.primaryKey)
        case .about: presentContentItem(id: bubbleTapped.primaryKey)
        case .privacy: presentContentItem(id: bubbleTapped.primaryKey)
        case .terms: presentContentItem(id: bubbleTapped.primaryKey)
        case .copyright: presentContentItem(id: bubbleTapped.primaryKey)
        case .contactSupport: presentMailComposer(recipients: [supportEmail()], subject: "ID: Support")
        case .featureRequest: presentMailComposer(recipients: [Defaults.firstLevelFeatureEmail], subject: "ID: Feature")
        case .tutorial: presentTutorial()
        case .faq: presentContentItem(id: bubbleTapped.primaryKey)
        }
    }
}

// MARK: - Private

private extension SettingsBubblesRouter {

    func presentContentItem(id: Int) {
		AppDelegate.current.appCoordinator.presentContentItemSettings(contentID: id,
																	  settingsViewController: viewController)
    }

    func presentTutorial() {
        let slideShowViewController = SlideShowViewController(configure: SlideShowConfigurator.makeModal())
        viewController.present(slideShowViewController, animated: true, completion: nil)
    }

    func presentMailComposer(recipients: [String], subject: String) {
        let composer = MFMailComposeViewController()
        composer.setToRecipients(recipients)
        composer.setSubject(subject)
        composer.mailComposeDelegate = self
        viewController.present(composer, animated: true, completion: nil)
    }

    func supportEmail() -> String {
        if let supportEmail = services.userService.user()?.firstLevelSupportEmail, supportEmail.isEmpty == false {
            return supportEmail
        }
        return Defaults.firstLevelSupportEmail
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension SettingsBubblesRouter: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        if let error = error {
            viewController.showAlert(type: .message(error.localizedDescription))
            log("Failed to open mail with error: \(error.localizedDescription))", level: .error)
        }
    }
}
