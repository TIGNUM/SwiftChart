//
//  MyVisionRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyVisionRouter {

    private let viewController: MyVisionViewController

    init(viewController: MyVisionViewController) {
        self.viewController = viewController
    }
}

extension MyVisionRouter: MyVisionRouterInterface {

    func showEditVision() {
        viewController.performSegue(withIdentifier: R.segue.myVisionViewController.myQotEditMyVisionSegueIdentifier, sender: nil)
    }

    func presentViewController(viewController: UIViewController, completion: (() -> Void)?) {
        self.viewController.present(viewController, animated: true, completion: completion)
    }

    func close() {
        viewController.dismiss(animated: true, completion: nil)
    }

    func openToBeVisionGenerator(permissionManager: PermissionsManager) {
        let configurator = DecisionTreeConfigurator.make(for: .toBeVisionGenerator, permissionsManager: permissionManager)
        let decisonTreeViewController = DecisionTreeViewController(configure: configurator)
        decisonTreeViewController.delegate = viewController
        viewController.present(decisonTreeViewController, animated: true, completion: nil)
    }
}
