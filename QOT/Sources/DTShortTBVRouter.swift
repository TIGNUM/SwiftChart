//
//  DTShortTBVRouter.swift
//  QOT
//
//  Created by karmic on 10.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTShortTBVRouter: DTRouter {

    override func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - DTShortTBVRouterInterface
extension DTShortTBVRouter: DTShortTBVRouterInterface {}
