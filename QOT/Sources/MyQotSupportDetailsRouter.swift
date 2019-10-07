//
//  MyQotSupportDetailsRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSupportDetailsRouter {
    // MARK: - Properties

    private weak var viewController: MyQotSupportDetailsViewController?

    // MARK: - Init

    init(viewController: MyQotSupportDetailsViewController) {
        self.viewController = viewController
    }
}

extension MyQotSupportDetailsRouter: MyQotSupportDetailsRouterInterface {

    func presentContentItemSettings(contentID: Int) {
        guard let articleViewController = R.storyboard.main.qotArticleViewController() else {
            assertionFailure("Failed to initialize `ArticleViewController`")
            return
        }
        ArticleConfigurator.configure(selectedID: contentID, viewController: articleViewController)
        viewController?.present(articleViewController, animated: true, completion: nil)
    }
}
