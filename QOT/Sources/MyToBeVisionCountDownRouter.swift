//
//  MyToBeVisionCountDownRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 21.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyToBeVisionCountDownRouter {
    private weak var viewController: MyToBeVisionCountDownViewController?

    init(viewController: MyToBeVisionCountDownViewController) {
        self.viewController = viewController
    }
}

extension MyToBeVisionCountDownRouter: MyToBeVisionCountDownRouterInterface {

}
