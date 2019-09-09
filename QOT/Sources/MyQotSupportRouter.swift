//
//  MyQotSupportRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import MessageUI

final class MyQotSupportRouter {

    // MARK: - Properties

    private let viewController: MyQotSupportViewController

    // MARK: - Init

    init(viewController: MyQotSupportViewController) {
        self.viewController = viewController
    }
}

extension MyQotSupportRouter: MyQotSupportRouterInterface {

    func handleSelection(for item: MyQotSupportModel.MyQotSupportModelItem, email: String) {
        switch item {
        case .contactSupport: showNovartisSupportIfNeeded(email: email, for: item)
        case .featureRequest: presentMailComposer(recipients: [Defaults.firstLevelFeatureEmail],
                                                  subject: "ID: Feature", id: item)
        case .tutorial: presentTutorial()
        case .faq: presentFAQ()
        }
    }
}

private extension MyQotSupportRouter {

    func showNovartisSupportIfNeeded(email: String, for item: MyQotSupportModel.MyQotSupportModelItem) {
        if Bundle.main.bundleIdentifier?.contains("novartis") == true {
            presentContentItem(id: item.primaryKey)
        } else {
            presentMailComposer(recipients: [email], subject: "ID: Support", id: item)
        }
    }

    func presentContentItem(id: Int) {
        guard let articleViewController = R.storyboard.main.qotArticleViewController() else {
            assertionFailure("Failed to initialize `ArticleViewController`")
            return
        }
        ArticleConfigurator.configure(selectedID: id, viewController: articleViewController)
        viewController.present(articleViewController, animated: true, completion: nil)
    }

    func presentFAQ() {
        viewController.performSegue(withIdentifier: R.segue.myQotSupportViewController.myQotSupportFaqSegueIdentifier, sender: nil)
    }

    func presentTutorial() {
        let configurator = TutorialConfigurator.make()
        let controller = TutorialViewController(configure: configurator, from: .settings)
        viewController.pushToStart(childViewController: controller)
    }

    func presentMailComposer(recipients: [String], subject: String, id: MyQotSupportModel.MyQotSupportModelItem) {
        guard MFMailComposeViewController.canSendMail() == true else {
            viewController.showAlert(type: .message(R.string.localized.alertMessageEmailNotSetup()))
            return
        }
        let composer = MFMailComposeViewController()
        composer.setToRecipients(recipients)
        composer.setSubject(subject)
        composer.mailComposeDelegate = viewController
        viewController.present(composer, animated: true, completion: nil)
    }
}
