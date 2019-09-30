//
//  WalkthroughCoachRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 23/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughCoachRouter {

    // MARK: - Properties

    private weak var viewController: WalkthroughCoachViewController?

    // MARK: - Init

    init(viewController: WalkthroughCoachViewController) {
        self.viewController = viewController
    }
}

// MARK: - WalkthroughCoachRouterInterface

extension WalkthroughCoachRouter: WalkthroughCoachRouterInterface {

}
