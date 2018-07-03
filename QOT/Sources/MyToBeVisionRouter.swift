//
//  MyToBeVisionRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 20/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class MyToBeVisionRouter {

    private let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension MyToBeVisionRouter: MyToBeVisionRouterInterface {

    func close() {
        viewController.dismiss(animated: true, completion: nil)
    }
}
