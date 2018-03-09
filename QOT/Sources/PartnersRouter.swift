//
//  ShareRouter.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import MessageUI

final class PartnersRouter: NSObject, PartnersRouterInterface {

    private let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
    }

    func showAlert(_ alert: AlertType) {
        viewController.showAlert(type: alert)
    }

    func showAlert(_ alert: UIAlertController) {
        viewController.present(alert, animated: true)
    }

    func showShare(partner: Partners.Partner) {
        guard let name = partner.name, let email = partner.email else {
            assertionFailure("partner must have name and email if this method is called")
            return
        }

        let configurator = ShareConfigurator.make(partnerLocalID: partner.localID,
                                                  partnerName: name,
                                                  partnerEmail: email)
        let shareViewController = ShareViewController(configure: configurator)
        let navController = UINavigationController(rootViewController: shareViewController)
        navController.navigationBar.applyDefaultStyle()
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .custom
        viewController.present(navController, animated: true, completion: nil)
    }

    func dismiss() {
        viewController.dismiss(animated: true, completion: nil)
    }
}
