//
//  SlideShowRouter.swift
//  QOT
//
//  Created by Sam Wyndham on 07.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class InitialSlideShowRouter: SlideShowRouterInterface {

    // FIXME: Remove AppCoordinator when we have migrated to a VIP architecture.
    private let appCoordinator: AppCoordinator

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func dismissSlideShow() {
        appCoordinator.showApp(loginViewController: nil)
    }
}

final class ModalSlideShowRouter: SlideShowRouterInterface {

    private let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func dismissSlideShow() {
        viewController.dismiss(animated: true, completion: nil)
    }
}
