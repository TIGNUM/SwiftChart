//
//  WalkthroughSwipeRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 23/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughSwipeRouter {

    // MARK: - Properties

    private weak var viewController: WalkthroughSwipeViewController?

    // MARK: - Init

    init(viewController: WalkthroughSwipeViewController) {
        self.viewController = viewController
    }
}

// MARK: - WalkthroughSwipeRouterInterface

extension WalkthroughSwipeRouter: WalkthroughSwipeRouterInterface {

}
