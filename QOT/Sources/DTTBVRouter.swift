//
//  DTTBVRouter.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTTBVRouter: DTRouter {

    // MARK: - Properties
    weak var delegate: MyVisionViewControllerScrollViewDelegate?

    // MARK: - DTRouter
    override func dismiss() {
        viewController?.dismiss(animated: true) { [weak self] in
            self?.delegate?.scrollToTop(true)
        }
    }
}

// MARK: - DTTBVRouterInterface
extension DTTBVRouter: DTTBVRouterInterface {}
