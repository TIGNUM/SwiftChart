//
//  MorningInterviewRouter.swift
//  QOT
//
//  Created by Sam Wyndham on 19/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class MorningInterviewRouter {

    // FIXME: Remove AppCoordinator when we have migrated to a VIP architecture.
    let appCoordinator: AppCoordinator
    let viewController: UIViewController

    init(viewController: UIViewController, appCoordinator: AppCoordinator) {
        self.viewController = viewController
        self.appCoordinator = appCoordinator
    }
}

extension MorningInterviewRouter: MorningInterviewRouterInterface {

    func close() {
        // FIXME: THIS VIEW CONTROLLER IS NOT USED
    }
}
