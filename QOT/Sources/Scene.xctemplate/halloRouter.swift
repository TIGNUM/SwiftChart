//
//  halloRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 07.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class halloRouter {

    // MARK: - Properties
    private weak var viewController: halloViewController?

    // MARK: - Init
    init(viewController: halloViewController?) {
        self.viewController = viewController
    }
}

// MARK: - halloRouterInterface
extension halloRouter: halloRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
