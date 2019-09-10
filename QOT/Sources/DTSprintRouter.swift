//
//  DTSprintRouter.swift
//  QOT
//
//  Created by karmic on 07.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTSprintRouter: DTRouter {

    // MARK: - Properties
    private weak var viewController: DTSprintViewController?

    // MARK: - Init
    init(viewController: DTSprintViewController?) {
        self.viewController = viewController
    }
}
