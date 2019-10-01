//
//  MyVisionRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyVisionRouter {

    private weak var viewController: MyVisionViewController?

    init(viewController: MyVisionViewController) {
        self.viewController = viewController
    }
}

extension MyVisionRouter: MyVisionRouterInterface {

    func showTracker() {
        guard let viewController = R.storyboard.myToBeVisionRate.myToBeVisionTrackerViewController() else { return }
        MyToBeVisionTrackerConfigurator.configure(viewController: viewController, controllerType: .tracker)
        self.viewController?.present(viewController, animated: true, completion: nil)
    }

    func showEditVision(title: String, vision: String, isFromNullState: Bool) {
        guard
            let controller = R.storyboard.myToBeVision.myVisionEditDetailsViewController(),
            let visionController = self.viewController else { return }
        MyVisionEditDetailsConfigurator.configure(viewController: controller,
                                                  title: title,
                                                  vision: vision,
                                                  isFromNullState: isFromNullState)
        visionController.present(controller, animated: true, completion: nil)
    }

    func showTBVData(shouldShowNullState: Bool, visionId: Int?) {
        if shouldShowNullState {
            guard let viewController = R.storyboard.myToBeVisionRate.myToBeVisionDataNullStateViewController() else { return }
            viewController.delegate = self.viewController
            viewController.visionId = visionId
            self.viewController?.present(viewController, animated: true, completion: nil)
            return
        }
        guard let viewController = R.storyboard.myToBeVisionRate.myToBeVisionTrackerViewController() else { return }
        MyToBeVisionTrackerConfigurator.configure(viewController: viewController, controllerType: .data)
        self.viewController?.present(viewController, animated: true, completion: nil)
    }

    func showRateScreen(with id: Int) {
        guard
            let viewController = R.storyboard.myToBeVisionRate.myToBeVisionRateViewController(),
            let visionController = self.viewController else { return }
        MyToBeVisionRateConfigurator.configure(previousController: visionController, viewController: viewController, visionId: id)
        visionController.present(viewController, animated: true, completion: nil)
    }

    func presentViewController(viewController: UIViewController, completion: (() -> Void)?) {
        self.viewController?.present(viewController, animated: true, completion: completion)
    }

    func openToBeVisionGenerator() {
        let configurator = DTTBVConfigurator.make(delegate: viewController)
        let controller = DTTBVViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }
}
