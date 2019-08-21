//
//  MyDataSelectionRouter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyDataSelectionRouter {

    // MARK: - Properties
    private weak var viewController: MyDataSelectionViewController?

    // MARK: - Init
    init(viewController: MyDataSelectionViewController?) {
        self.viewController = viewController
    }
}

// MARK: - MyDataSelectionRouterInterface
extension MyDataSelectionRouter: MyDataSelectionRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
