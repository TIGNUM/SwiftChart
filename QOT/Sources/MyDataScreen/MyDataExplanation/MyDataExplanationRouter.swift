//
//  MyDataExplanationRouter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyDataExplanationRouter {

    // MARK: - Properties
    private weak var viewController: MyDataExplanationViewController?

    // MARK: - Init
    init(viewController: MyDataExplanationViewController?) {
        self.viewController = viewController
    }
}

// MARK: - MyDataExplanationRouterInterface
extension MyDataExplanationRouter: MyDataExplanationRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
