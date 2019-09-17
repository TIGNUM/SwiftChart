//
//  DTShortTBVRouter.swift
//  QOT
//
//  Created by karmic on 10.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTShortTBVRouter: DTRouter {

    // MARK: - Properties
    weak var shortTBVViewController: DTShortTBVViewController?
}

// MARK: - DTShortTBVRouterInterface
extension DTShortTBVRouter: DTShortTBVRouterInterface {
    func dismissShortTBVFlow() {
        shortTBVViewController?.dismiss(animated: true, completion: nil)
    }
}
