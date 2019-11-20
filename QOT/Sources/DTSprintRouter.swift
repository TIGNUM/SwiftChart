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

    func presentMySprintsViewController() {
        guard let mySprintsController = R.storyboard.mySprints.mySprintsListViewController() else {
            return
        }
        let configurator = MySprintsListConfigurator.make()
        configurator(mySprintsController)
        viewController?.pushToStart(childViewController: mySprintsController)
        viewController?.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
