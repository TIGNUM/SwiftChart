//
//  MyToBeVisionNullStateRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 19.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyVisionNullStateRouter {

    private let viewController: MyVisionNullStateViewController

    init(viewController: MyVisionNullStateViewController) {
        self.viewController = viewController
    }
}

extension MyVisionNullStateRouter: MyVisionNullStateRouterInterface {
    func openToBeVisionGenerator() {}
    func openToBeVisionEditController() {}
}
