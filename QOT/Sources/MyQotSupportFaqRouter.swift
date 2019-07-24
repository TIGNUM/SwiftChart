//
//  MyQotSupportFaqRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSupportFaqRouter {
    // MARK: - Properties

    private let viewController: MyQotSupportFaqViewController

    // MARK: - Init

    init(viewController: MyQotSupportFaqViewController) {
        self.viewController = viewController
    }
}

extension MyQotSupportFaqRouter: MyQotSupportFaqRouterInterface {

    func presentContentItemSettings(contentID: Int) {
        guard let articleViewController = R.storyboard.main.qotArticleViewController() else {
            assertionFailure("Failed to initialize `ArticleViewController`")
            return
        }
        ArticleConfigurator.configure(selectedID: contentID, viewController: articleViewController)
        viewController.present(articleViewController, animated: true, completion: nil)
    }
}
