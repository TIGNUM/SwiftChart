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
        guard let controller = R.storyboard.myToBeVisionRate.myToBeVisionTrackerViewController() else { return }
        MyToBeVisionTrackerConfigurator.configure(viewController: controller, controllerType: .tracker)
        viewController?.dismiss(animated: false, completion: {
            self.viewController?.present(controller, animated: true)
        })
    }
}
