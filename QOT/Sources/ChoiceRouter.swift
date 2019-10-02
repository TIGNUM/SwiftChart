//
//  ChoiceRouter.swift
//  QOT
//
//  Created by karmic on 21.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ChoiceRouter {

    // MARK: - Properties

    private weak var viewController: ChoiceViewController?

    // MARK: - Init

    init(viewController: ChoiceViewController) {
        self.viewController = viewController
    }
}

// MARK: - ChoiceRouterInterface

extension ChoiceRouter: ChoiceRouterInterface {

}
