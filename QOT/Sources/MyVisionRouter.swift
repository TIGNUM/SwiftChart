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

    func showUpdateConfirmationScreen() {
        let config = PopUpViewController.Config(title: "UPDATE TO BE VISION",
                                                description: "Do you wanna create a new To Be Vision or edit your current one?",
                                                rightButtonTitle: "Edit", leftButtonTitle: "Create new")
        let popUpController = PopUpViewController(with: config, delegate: viewController)
        popUpController.modalPresentationStyle = .overCurrentContext
        viewController.present(popUpController, animated: true, completion: nil)
    }

    func openToBeVisionGenerator() {
        let configurator = DecisionTreeConfigurator.make(for: .toBeVisionGenerator)
        let decisonTreeViewController = DecisionTreeViewController(configure: configurator)
        decisonTreeViewController.delegate = viewController
        viewController.present(decisonTreeViewController, animated: true, completion: nil)
    }
}
