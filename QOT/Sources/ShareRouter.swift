//
//  ShareRouter.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import MessageUI

final class ShareRouter: NSObject {

    private let viewController: ShareViewController

    init(viewController: ShareViewController) {
        self.viewController = viewController
        super.init()
    }
}

// MARK: - ShareRouterInterface

extension ShareRouter: ShareRouterInterface {

    func showEditPartner(partner: Partners.Partner?) {
        guard let partner = partner else { return }
        let configurator = PartnerEditConfigurator.make(partnerToEdit: partner)
        let partnersController = PartnerEditViewController(configure: configurator)
        let navController = UINavigationController(rootViewController: partnersController)
        navController.navigationBar.applyDefaultStyle()
        navController.transitioningDelegate = partnersController.transitioningDelegate
        viewController.present(navController, animated: true, completion: nil)
    }

    func dismiss() {
        viewController.dismiss(animated: true) {
            NotificationCenter.default.post(name: .didDismissView, object: nil)
        }
    }

    func showMailComposer(email: String, subject: String, messageBody: String) {
        guard MFMailComposeViewController.canSendMail() == true else {
            showAlert(.message(R.string.localized.alertMessageEmailNotSetup()))
            return
        }

        let composer = MFMailComposeViewController()
        composer.setToRecipients([email])
        composer.setSubject(subject)
        composer.setMessageBody(messageBody, isHTML: true)
        composer.mailComposeDelegate = self
        viewController.present(composer, animated: true, completion: nil)
    }

    func showAlert(_ alert: AlertType) {
        viewController.showAlert(type: alert)
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension ShareRouter: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        if let error = error {
            showAlert(.message(error.localizedDescription))
            log("Failed to open mail with error: \(error.localizedDescription))", level: .error)
        }
    }
}
