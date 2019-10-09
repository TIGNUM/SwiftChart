//
//  ArticleRouter.swift
//  QOT
//
//  Created by karmic on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import MessageUI
import qot_dal

final class ArticleRouter {

    // MARK: - Properties

    private weak var viewController: ArticleViewController?

    // MARK: - Init

    init(viewController: ArticleViewController) {
        self.viewController = viewController
    }

    func presentMailComposer(recipients: [String], subject: String, id: Article.Item?) {
        guard MFMailComposeViewController.canSendMail() == true else {
            viewController?.showAlert(type: .message(AppTextService.get(AppTextKey.my_qot_my_profile_support_article_alert_email_try_again)))
            return
        }
        let composer = MFMailComposeViewController()
        composer.setToRecipients(recipients)
        composer.setSubject(subject)
        composer.mailComposeDelegate = viewController
        viewController?.present(composer, animated: true, completion: nil)
    }
}

// MARK: - ArticleRouterInterface

extension ArticleRouter: ArticleRouterInterface {
    func didTapLink(_ url: URL) {
        if url.scheme == "mailto" && UIApplication.shared.canOpenURL(url) == true {
            UIApplication.shared.open(url)
        } else {
            do {
                viewController?.present(try WebViewController(url), animated: true, completion: nil)
            } catch {
                log("Failed to open url. Error: \(error)", level: .error)
                viewController?.showAlert(type: .message(error.localizedDescription))
            }
        }
    }

    func openSupportEmailComposer(for item: Article.Item?, emailAdress: String?) {
        presentMailComposer(recipients: [emailAdress ?? Defaults.firstLevelSupportEmail],
                            subject: "ID: Support", id: item)
    }
}
