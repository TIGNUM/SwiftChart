//
//  WalkthroughRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughRouter {

    // MARK: - Properties

    private let viewController: WalkthroughViewController

    // MARK: - Init

    init(viewController: WalkthroughViewController) {
        self.viewController = viewController
    }
}

// MARK: - WalkthroughRouterInterface

extension WalkthroughRouter: WalkthroughRouterInterface {
    func navigateToMainApp() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.appCoordinator.showApp()
    }
}
