//
//  MyDataScreenRouter.swift
//  
//
//  Created by Simu Voicu-Mircea on 19/08/2019.
//  Copyright (c) 2019 TIGNUM GmbH. All rights reserved.
//

import UIKit

final class MyDataScreenRouter {

    // MARK: - Properties
    private weak var viewController: MyDataScreenViewController?

    // MARK: - Init
    init(viewController: MyDataScreenViewController?) {
        self.viewController = viewController
    }
}

// MARK: - MyDataScreenRouterInterface
extension MyDataScreenRouter: MyDataScreenRouterInterface {
    func presentMyDataExplanation(withType: MyDataSection) {
        viewController?.performSegue(withIdentifier: R.segue.myDataScreenViewController.mydataExplanationSegueIdentifier, sender: withType)
    }

    func passDataToScene(segue: UIStoryboardSegue, withType: MyDataSection) {
        if let myDataExplanationViewController = segue.destination as? MyDataExplanationViewController {
            let configurator = MyDataExplanationConfigurator.make()
            configurator(myDataExplanationViewController, withType)
        } else if let myDataSelectionViewController  = segue.destination as? MyDataSelectionViewController {
            myDataSelectionViewController.delegate = viewController
        }
    }

    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func presentMyDataSelection() {
        viewController?.performSegue(withIdentifier: R.segue.myDataScreenViewController.mydataSelectionSegueIdentifier, sender: nil)
    }
}
