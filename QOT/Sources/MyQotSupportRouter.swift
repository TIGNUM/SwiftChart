//
//  MyQotSupportRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import MessageUI
import qot_dal

final class MyQotSupportRouter {

    // MARK: - Properties

    private weak var viewController: MyQotSupportViewController?

    // MARK: - Init

    init(viewController: MyQotSupportViewController) {
        self.viewController = viewController
    }
}

extension MyQotSupportRouter: MyQotSupportRouterInterface {

    func handleSelection(for item: MyQotSupportModel.MyQotSupportModelItem, email: String) {
        switch item {
        case .usingQOT: presentUsingQOT()
        case .faq: presentFAQ()
        case .reportIssue: presentMailComposer(recipients: [Defaults.firstLevelSupportEmail],
                                               subject: "ID: Support", id: item)
        case .featureRequest: presentMailComposer(recipients: [Defaults.firstLevelFeatureEmail],
                                                  subject: "ID: Feature", id: item)
        }
    }
}

private extension MyQotSupportRouter {
    func presentContentItem(id: Int) {
        guard let articleViewController = R.storyboard.main.qotArticleViewController() else {
            assertionFailure("Failed to initialize `ArticleViewController`")
            return
        }
        ArticleConfigurator.configure(selectedID: id, viewController: articleViewController)
        viewController?.present(articleViewController, animated: true, completion: nil)
    }

    func presentFAQ() {
        viewController?.performSegue(withIdentifier: R.segue.myQotSupportViewController.myQotSupportDetailsSegueIdentifier, sender: ContentCategory.FAQ)
    }

    func presentUsingQOT() {
        viewController?.performSegue(withIdentifier: R.segue.myQotSupportViewController.myQotSupportDetailsSegueIdentifier, sender: ContentCategory.UsingQOT)
    }

    func presentMailComposer(recipients: [String], subject: String, id: MyQotSupportModel.MyQotSupportModelItem) {
        guard MFMailComposeViewController.canSendMail() == true else {
            viewController?.showAlert(type: .message(AppTextService.get(AppTextKey.my_qot_my_profile_support_alert_body_email_try_again)))
            return
        }
        let composer = MFMailComposeViewController()
        composer.setToRecipients(recipients)
        composer.setSubject(subject)
        composer.mailComposeDelegate = viewController
        viewController?.present(composer, animated: true, completion: nil)
    }
}
