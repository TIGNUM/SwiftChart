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

    private let viewController: RegistrationCodeViewController

    // MARK: - Init

    init(viewController: RegistrationCodeViewController) {
        self.viewController = viewController
    }
}

// MARK: - RegistrationCodeRouterInterface

extension RegistrationCodeRouter: RegistrationCodeRouterInterface {
    func showPrivacyPolicy() {
        showArticle(with: MyQotAboutUsModel.MyQotAboutUsModelItem.privacy.primaryKey)
    }

    func showTermsOfUse() {
        showArticle(with: MyQotAboutUsModel.MyQotAboutUsModelItem.terms.primaryKey)
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
        viewController.present(controller, animated: true, completion: nil)
    }
}
