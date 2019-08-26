//
//  WalkthroughSearchRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughSearchRouter {

    // MARK: - Properties

    private let viewController: WalkthroughSearchViewController

    // MARK: - Init

    init(viewController: WalkthroughSearchViewController) {
        self.viewController = viewController
    }
}

// MARK: - WalkthroughSearchRouterInterface

extension WalkthroughSearchRouter: WalkthroughSearchRouterInterface {

}
