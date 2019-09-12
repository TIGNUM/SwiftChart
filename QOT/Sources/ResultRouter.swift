//
//  ResultRouter.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ResultRouter {

    // MARK: - Properties
    private weak var viewController: ResultViewController?

    // MARK: - Init
    init(viewController: ResultViewController?) {
        self.viewController = viewController
    }
}

// MARK: - ResultRouterInterface
extension ResultRouter: ResultRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
