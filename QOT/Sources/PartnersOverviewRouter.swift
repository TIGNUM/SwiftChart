//
//  PartnersOverviewRouter.swift
//  QOT
//
//  Created by karmic on 15.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit
import MessageUI

final class PartnersOverviewRouter: NSObject {

    // MARK: - Properties

    private let viewController: PartnersOverviewViewController

    // MARK: - Init

    init(viewController: PartnersOverviewViewController) {
        self.viewController = viewController
    }
}

// MARK: - PartnersOverviewRouterInterface

extension PartnersOverviewRouter: PartnersOverviewRouterInterface {

    func showShare(partner: Partner) {
        guard let relationship = partner.relationship else {
            assertionFailure("partner must have name and email if this method is called")
            return
        }
        let configurator = ShareConfigurator.make(partnerLocalID: partner.localID,
                                                  partnerName: partner.name,
                                                  partnerSurname: partner.surname,
                                                  partnerRelationship: relationship,
                                                  partnerImageURL: partner.profileImageResource?.url,
                                                  partnerInitials: partner.initials,
                                                  partnerEmail: partner.email)
        let shareViewController = ShareViewController(configure: configurator)
        let navController = UINavigationController(rootViewController: shareViewController)
        navController.navigationBar.applyDefaultStyle()
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .custom
        viewController.present(navController, animated: true, completion: nil)
    }

    func showMailComposer(email: String, subject: String, messageBody: String) {
        guard MFMailComposeViewController.canSendMail() == true else {
            showAlert(.message(R.string.localized.alertMessateEmailNotSetup()))
            return
        }

        let composer = MFMailComposeViewController()
        composer.setToRecipients([email])
        composer.setSubject(subject)
        composer.setMessageBody(messageBody, isHTML: true)
        composer.mailComposeDelegate = self
        viewController.present(composer, animated: true, completion: nil)
    }

    func showEditPartner(partner: Partner) {
        showPartner(partner: partner)
    }

    func showAlert(_ alert: AlertType) {
        viewController.showAlert(type: alert)
    }

    func showAddPartner(partner: Partner) {
        showPartner(partner: partner, isNewPartner: true)
    }

    func showPartner(partner: Partner, isNewPartner: Bool = false) {
        let configurator = PartnerEditConfigurator.make(partnerToEdit: Partners.Partner(partner), isNewPartner: isNewPartner)
        let partnersController = PartnerEditViewController(configure: configurator)
        partnersController.title = R.string.localized.meSectorMyWhyPartnersTitle().uppercased()
        let navController = UINavigationController(rootViewController: partnersController)
        navController.navigationBar.applyDefaultStyle()
        navController.transitioningDelegate = partnersController.transitioningDelegate
        viewController.present(navController, animated: true, completion: nil)
    }

    func dismiss() {
        viewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension PartnersOverviewRouter: MFMailComposeViewControllerDelegate {

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
