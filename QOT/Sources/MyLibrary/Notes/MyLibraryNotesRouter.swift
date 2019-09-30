//
//  MyLibraryNotesRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 11/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyLibraryNotesRouter {

    // MARK: - Properties

    private weak var viewController: MyLibraryNotesViewController?

    // MARK: - Init

    init(viewController: MyLibraryNotesViewController) {
        self.viewController = viewController
    }
}

// MARK: - MyLibraryNotesRouterInterface

extension MyLibraryNotesRouter: MyLibraryNotesRouterInterface {
    func dismiss() {
        viewController?.didTapDismissButton()
    }
}
