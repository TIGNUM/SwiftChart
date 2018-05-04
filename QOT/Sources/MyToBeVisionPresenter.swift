//
//  MyToBeVisionPresenter.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 20/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class MyToBeVisionPresenter: MyToBeVisionPresenterInterface {

    private weak var viewController: MyToBeVisionViewControllerInterface?

    init(viewController: MyToBeVisionViewControllerInterface) {
        self.viewController = viewController
    }

    func loadToBeVision(_ toBeVision: MyToBeVisionModel.Model) {
        viewController?.setup(with: toBeVision)
    }

    func updateToBeVision(_ toBeVision: MyToBeVisionModel.Model) {
        viewController?.update(with: toBeVision)
    }

    func presentImageError(_ error: Error) {
        viewController?.displayImageError()
        log("Failed to load TBV image with error: \(error.localizedDescription))", level: .error)
    }

    func presentVisionGenerator() {
        viewController?.showVisionGenerator()
    }
}
