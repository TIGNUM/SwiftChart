//
//  MyQotAboutUsRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import MessageUI

final class MyQotAboutUsRouter {

    // MARK: - Properties

    private weak var viewController: MyQotAboutUsViewController?

    // MARK: - Init

    init(viewController: MyQotAboutUsViewController) {
        self.viewController = viewController
    }
}

extension MyQotAboutUsRouter: MyQotAboutUsRouterInterface {
    func handleSelection(for item: MyQotAboutUsModel.MyQotAboutUsModelItem) {
        switch item {
        case .benefits: presentContentItem(id: item.primaryKey)
        case .about: presentContentItem(id: item.primaryKey)
        case .privacy: presentContentItem(id: item.primaryKey)
        case .terms: presentContentItem(id: item.primaryKey)
        case .copyright: presentContentItem(id: item.primaryKey)
        }
    }
}

private extension MyQotAboutUsRouter {

    func presentContentItem(id: Int) {
        guard let articleViewController = R.storyboard.main.qotArticleViewController() else {
            assertionFailure("Failed to initialize `ArticleViewController`")
            return
        }
        ArticleConfigurator.configure(selectedID: id, viewController: articleViewController)
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromTop
        viewController?.view.window?.layer.add(transition, forKey: kCATransition)
        viewController?.present(articleViewController, animated: false, completion: nil)
    }
}
