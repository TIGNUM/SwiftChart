//
//  ResultsPrepareRouter.swift
//  QOT
//
//  Created by karmic on 11.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class ResultsPrepareRouter {

    // MARK: - Properties
    private weak var viewController: ResultsPrepareViewController?

    // MARK: - Init
    init(viewController: ResultsPrepareViewController?) {
        self.viewController = viewController
    }
}

// MARK: - ResultsPrepareRouterInterface
extension ResultsPrepareRouter: ResultsPrepareRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func presentContent(_ contentId: Int) {
        AppDelegate.current.launchHandler.showContentCollection(contentId)
    }
}
