//
//  DTSprintRouter.swift
//  QOT
//
//  Created by karmic on 07.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTSprintRouter: DTRouter {
    func openPermissionView(_ permissionType: AskPermission.Kind) {
        guard let controller = R.storyboard.askPermission().instantiateInitialViewController() as?
            AskPermissionViewController else { return }
        AskPermissionConfigurator.make(viewController: controller, type: permissionType)
        viewController?.present(controller, animated: true, completion: nil)
    }

    func presentMySprintsViewController(_ isPresentedFromCoach: Bool) {
        guard let mySprintsController = R.storyboard.mySprints.mySprintsListViewController() else {
            return
        }
        let configurator = MySprintsListConfigurator.make()
        configurator(mySprintsController)
        if isPresentedFromCoach, let vc = viewController {
            vc.pushToStart(childViewController: mySprintsController)
            vc.view.alpha = 0.0
            vc.presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            viewController?.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
