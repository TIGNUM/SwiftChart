//
//  DTMindsetRouter.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTMindsetRouter: DTRouter {

    // MARK: - Properties
    private weak var viewController: DTMindsetViewController?

    // MARK: - Init
    init(viewController: DTMindsetViewController?) {
        self.viewController = viewController
    }
}

// MARK: - DTMindsetRouterInterface
extension DTMindsetRouter: DTMindsetRouterInterface {}
