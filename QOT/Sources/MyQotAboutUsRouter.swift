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

    private let viewController: MyQotAboutUsViewController

    // MARK: - Init

    init(viewController: MyQotAboutUsViewController) {
        self.viewController = viewController
    }
}

extension MyQotAboutUsRouter: MyQotAboutUsRouterInterface {
    func handleSelection(for item: MyQotAboutUsModel.MyQotAboutUsModelItem) {
        switch item {
        case .benefits: presentContentItem(id: item.primaryKey, pageName: item.pageName)
        case .about: presentContentItem(id: item.primaryKey, pageName: item.pageName)
        case .privacy: presentContentItem(id: item.primaryKey, pageName: item.pageName)
        case .terms: presentContentItem(id: item.primaryKey, pageName: item.pageName)
        case .copyright: presentContentItem(id: item.primaryKey, pageName: item.pageName)
        }
    }
}

private extension MyQotAboutUsRouter {
    func presentContentItem(id: Int, pageName: PageName) {
        AppDelegate.current.appCoordinator.presentContentItemSettings(contentID: id,
                                                                      controller: viewController,
                                                                      pageName: pageName,
                                                                      topBarTitle: "Faq")
    }
}
