//
//  MyToBeVisionRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 20/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class MyToBeVisionRouter {

    // FIXME: Remove AppCoordinator when we have migrated to a VIP architecture.
    let appCoordinator: AppCoordinator
    let viewController: UIViewController

    init(viewController: UIViewController, appCoordinator: AppCoordinator) {
        self.viewController = viewController
        self.appCoordinator = appCoordinator
    }
}

extension MyToBeVisionRouter: MyToBeVisionRouterInterface {

    func close() {
        appCoordinator.dismiss(viewController, level: .priority)
    }
}
