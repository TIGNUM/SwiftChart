//
//  DTRecoveryRouter.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTRecoveryRouter: DTRouter {}

// MARK: - DTRecoveryRouterInterface
extension DTRecoveryRouter: DTRecoveryRouterInterface {
    func presentRecoveryResults(_ recovery: QDMRecovery3D?, _ completion: (() -> Void)?) {
        let configurator = SolveResultsConfigurator.make(from: recovery, canDelete: true)
        let controller = SolveResultsViewController(configure: configurator)
        viewController?.present(controller, animated: true, completion: completion)
        controller.delegate = self
    }

    func dimissRecoveryFlow() {
        if let pageViewController = viewController?.childViewControllers.first as? UIPageViewController {
            pageViewController.childViewControllers.forEach { (viewController) in
                viewController.dismiss(animated: false, completion: nil)
            }
        }
        viewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - ResultsViewControllerDelegate
extension DTRecoveryRouter: ResultsViewControllerDelegate {
    func didTapDismiss() {
        dimissRecoveryFlow()
    }
}
