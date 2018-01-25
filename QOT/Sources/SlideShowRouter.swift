//
//  SlideShowRouter.swift
//  QOT
//
//  Created by Sam Wyndham on 07.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SlideShowRouter {

    // FIXME: Remove AppCoordinator when we have migrated to a VIP architecture.
    let appCoordinator: AppCoordinator

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
}

extension SlideShowRouter: SlideShowRouterInterface {

    func dismissSlideShow() {
        appCoordinator.showApp(loginViewController: nil)
    }
}
