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
    private var popUpController: PopUpViewController?

    init(viewController: MyVisionViewController) {
        self.viewController = viewController
    }
}

extension MyVisionRouter: MyVisionRouterInterface {

    func showTracker() {
        guard let vieController = R.storyboard.myToBeVisionRate.myToBeVisionTrackerViewController() else { return }
        MyToBeVisionTrackerConfigurator.configure(viewController: vieController, controllerType: .tracker)
        viewController?.present(vieController, animated: true, completion: nil)
    }

    func showEditVision(title: String, vision: String, isFromNullState: Bool) {
        guard
            let controller = R.storyboard.myToBeVision.myVisionEditDetailsViewController(),
            let visionController = self.viewController else { return }
        MyVisionEditDetailsConfigurator.configure(originViewController: visionController,
                                                  viewController: controller,
                                                  title: title,
                                                  vision: vision,
                                                  isFromNullState: isFromNullState)
        viewController?.present(controller, animated: true, completion: nil)
    }

    func showTBVData(shouldShowNullState: Bool, visionId: Int?) {
        if shouldShowNullState {
            guard let vieController = R.storyboard.myToBeVisionRate.myToBeVisionDataNullStateViewController() else { return }
            vieController.delegate = viewController
            vieController.visionId = visionId
            viewController?.present(vieController, animated: true, completion: nil)
            return
        }
        guard let vieController = R.storyboard.myToBeVisionRate.myToBeVisionTrackerViewController() else { return }
        MyToBeVisionTrackerConfigurator.configure(viewController: vieController, controllerType: .data)
        viewController?.present(vieController, animated: true, completion: nil)
    }

    func showRateScreen(with id: Int) {
        guard
            let vieController = R.storyboard.myToBeVisionRate.myToBeVisionRateViewController(),
            let visionController = self.viewController else { return }
        MyToBeVisionRateConfigurator.configure(previousController: visionController, viewController: vieController, visionId: id)
        viewController?.present(vieController, animated: true, completion: nil)
    }

    func presentViewController(viewController: UIViewController, completion: (() -> Void)?) {
        self.viewController?.present(viewController, animated: true, completion: completion)
    }

    func closeUpdateConfirmationScreen(completion: (() -> Void)?) {
        self.popUpController?.dismiss(animated: true, completion: completion)
    }

    ///FIXME Actually we are not showing the confirmation view.
    func showUpdateConfirmationScreen() {
        let config = PopUpViewController.Config(title: "UPDATE TO BE VISION",
                                                description: "Do you wanna create a new To Be Vision or edit your current one?",
                                                rightButtonTitle: "Edit", leftButtonTitle: "Create new")
        let popUpController = PopUpViewController(with: config, delegate: viewController)
        popUpController.modalPresentationStyle = .overCurrentContext
        self.popUpController = popUpController
        viewController?.present(popUpController, animated: true, completion: nil)
    }

    func openToBeVisionGenerator() {
        let configurator = DecisionTreeConfigurator.make(for: .toBeVisionGenerator)
        let decisonTreeViewController = DecisionTreeViewController(configure: configurator)
        decisonTreeViewController.delegate = viewController
        viewController?.present(decisonTreeViewController, animated: true, completion: nil)
    }
}
