//
//  MyToBeVisionRateRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyToBeVisionRateRouter {

    private weak var viewController: MyToBeVisionRateViewController?

    init(viewController: MyToBeVisionRateViewController) {
        self.viewController = viewController
    }
}

extension MyToBeVisionRateRouter: MyToBeVisionRateRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
