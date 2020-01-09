//
//  DTRouter.swift
//  QOT
//
//  Created by karmic on 10.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

class DTRouter: BaseRouter, DTRouterInterface {
    func goBackToSolveResult() {
        if let pageViewController = viewController?.childViewControllers.first as? UIPageViewController {
            pageViewController.childViewControllers.forEach { (viewController) in
                viewController.dismiss(animated: false, completion: nil)
            }
        }
        viewController?.dismiss(animated: true, completion: nil)
    }
}
