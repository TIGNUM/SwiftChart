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
    private var supportFAQController: SupportFAQViewController?

    init(viewController: SettingsBubblesViewController, services: Services) {
        self.viewController = viewController
        self.services = services
    }
}

// MARK: - SettingsBubblesRouter Interface

extension SettingsBubblesRouter: SettingsBubblesRouterInterface {

    func handleSelection(bubbleTapped: SettingsBubblesModel.SettingsBubblesItem) {
        switch bubbleTapped {
        case .benefits: presentContentItem(id: bubbleTapped.primaryKey, pageName: bubbleTapped.pageName)
        case .about: presentContentItem(id: bubbleTapped.primaryKey, pageName: bubbleTapped.pageName)
        case .privacy: presentContentItem(id: bubbleTapped.primaryKey, pageName: bubbleTapped.pageName)
        case .terms: presentContentItem(id: bubbleTapped.primaryKey, pageName: bubbleTapped.pageName)
        case .copyright: presentContentItem(id: bubbleTapped.primaryKey, pageName: bubbleTapped.pageName)
        case .contactSupport: showNovartisSupportIfNeeded(bubbleTapped: bubbleTapped)
        case .featureRequest: presentMailComposer(recipients: [Defaults.firstLevelFeatureEmail],
                                                  subject: "ID: Feature", id: bubbleTapped)
        case .tutorial: presentTutorial()
        case .faq: presentFAQ()
        }
    }
}

// MARK: - Private

private extension SettingsBubblesRouter {

    func showNovartisSupportIfNeeded(bubbleTapped: SettingsBubblesModel.SettingsBubblesItem) {
        if Bundle.main.bundleIdentifier?.contains("novartis") == true {
            presentContentItem(id: bubbleTapped.primaryKey, pageName: bubbleTapped.pageName)
        } else {
            presentMailComposer(recipients: [supportEmail()], subject: "ID: Support", id: bubbleTapped)
        }
    }

    func presentContentItem(id: Int, pageName: PageName) {
        AppDelegate.current.appCoordinator.presentContentItemSettings(contentID: id,
                                                                      controller: viewController,
                                                                      pageName: pageName)
    }

    func presentFAQ() {
        let configurator = SupportFAQConfigurator.make()
        let controller = SupportFAQViewController(configure: configurator)
        viewController.pushToStart(childViewController: controller)
    }

    func presentTutorial() {
        let configurator = TutorialConfigurator.make()
        let controller = TutorialViewController(configure: configurator, from: .settings)
        viewController.pushToStart(childViewController: controller)
    }

    func presentMailComposer(recipients: [String], subject: String, id: SettingsBubblesModel.SettingsBubblesItem) {
        guard MFMailComposeViewController.canSendMail() == true else {
            viewController.showAlert(type: .message(R.string.localized.alertMessageEmailNotSetup()))
            return
        }
        let pageName: PageName = id == .contactSupport ? .supportContact : .featureRequest
        let composer = MFMailComposeViewController(pageName: pageName)
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
