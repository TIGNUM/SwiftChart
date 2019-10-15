//
//  RegistrationCodeRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 10/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationCodeRouter {

    // MARK: - Properties
    private weak var viewController: RegistrationCodeViewController?

    // MARK: - Init
    init(viewController: RegistrationCodeViewController) {
        self.viewController = viewController
    }
}

// MARK: - RegistrationCodeRouterInterface
extension RegistrationCodeRouter: RegistrationCodeRouterInterface {
    func showPrivacyPolicy() {
        let value = MyQotAboutUsModel.MyQotAboutUsModelItem.privacy.primaryKey
        viewController?.trackUserEvent(.OPEN, value: value, valueType: .SHOW_PRIVACY_POLICY, action: .TAP)
        showArticle(with: value)
    }

    func showTermsOfUse() {
        let value = MyQotAboutUsModel.MyQotAboutUsModelItem.terms.primaryKey
        viewController?.trackUserEvent(.OPEN, value: value, valueType: .SHOW_TERMS_OF_USE, action: .TAP)
        showArticle(with: value)
    }

    func showFAQScreen() {
        let identifier = R.storyboard.myQot.myQotSupportDetailsViewController.identifier
        if let controller = R.storyboard
            .myQot().instantiateViewController(withIdentifier: identifier) as? MyQotSupportDetailsViewController {
            MyQotSupportDetailsConfigurator.configure(viewController: controller, category: .FAQBeforeLogin)
            viewController?.present(controller, animated: true, completion: nil)
        }
    }
}

// Private methods
private extension RegistrationCodeRouter {
    func showArticle(with id: Int) {
        guard let controller = R.storyboard.main()
            .instantiateViewController(withIdentifier: R.storyboard.main.qotArticleViewController.identifier)
            as? ArticleViewController else {
                return
        }
        ArticleConfigurator.configure(selectedID: id, viewController: controller)
        viewController?.present(controller, animated: true, completion: nil)
    }
}
