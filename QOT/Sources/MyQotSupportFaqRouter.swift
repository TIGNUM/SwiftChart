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
    
    func presentContentItemSettings(contentID: Int, pageName: PageName, pageTitle: String) {
        AppDelegate.current.appCoordinator.presentContentItemSettings(contentID: contentID,
                                                                      controller: viewController,
                                                                      pageName: pageName,
                                                                      topBarTitle: pageTitle)
    }
}
