//
//  MySprintNotesRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 11/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MySprintNotesRouter {

    // MARK: - Properties

    private weak var viewController: MySprintNotesViewController?

    // MARK: - Init

    init(viewController: MySprintNotesViewController) {
        self.viewController = viewController
    }
}

// MARK: - MySprintNotesRouterInterface

extension MySprintNotesRouter: MySprintNotesRouterInterface {
    func dismiss() {
        viewController?.didTapDismissButton()
    }
}
