//
//  DTPrepareStartRouter.swift
//  QOT
//
//  Created by karmic on 19.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class DTPrepareStartRouter {

    // MARK: - Properties
    private weak var viewController: DTPrepareStartViewController?

    // MARK: - Init
    init(viewController: DTPrepareStartViewController?) {
        self.viewController = viewController
    }
}

// MARK: - DTPrepareStartRouterInterface
extension DTPrepareStartRouter: DTPrepareStartRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
