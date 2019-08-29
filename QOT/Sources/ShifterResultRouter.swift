//
//  ShifterResultRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ShifterResultRouter {

    // MARK: - Properties
    private let viewController: ShifterResultViewController

    // MARK: - Init
    init(viewController: ShifterResultViewController) {
        self.viewController = viewController
    }
}

// MARK: - ShifterResultRouterInterface
extension ShifterResultRouter: ShifterResultRouterInterface {
    func dismiss() {
        viewController.dismiss(animated: true, completion: nil)
    }
}
