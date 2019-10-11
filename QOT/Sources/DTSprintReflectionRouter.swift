//
//  DTSprintReflectionRouter.swift
//  QOT
//
//  Created by Michael Karbe on 17.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTSprintReflectionRouter: DTRouter {}

// MARK: - DTSprintReflectionRouterInterface
extension DTSprintReflectionRouter: DTSprintReflectionRouterInterface {
    func presentTrackTBV() {
        let identifier = R.storyboard.myToBeVision.myVisionViewController.identifier
        guard let controller = R.storyboard.myToBeVision()
            .instantiateViewController(withIdentifier: identifier) as? MyVisionViewController else { return }
        MyVisionConfigurator.configure(viewController: controller)

        guard let rateController = R.storyboard.myToBeVisionRate.myToBeVisionRateViewController() else { return }
        WorkerTBV().getUsersTBV { [weak self] (tbv, _) in
            MyToBeVisionRateConfigurator.configure(previousController: controller,
                                                   viewController: rateController,
                                                   visionId: tbv?.remoteID ?? 0)
            self?.viewController?.dismiss(animated: false) {
                self?.viewController?.present(rateController, animated: true)
            }
        }
    }
}
