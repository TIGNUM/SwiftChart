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
    private let options: [LaunchOption: String?]

    init(viewController: MyToBeVisionViewControllerInterface, options: [LaunchOption: String?]? = nil) {
        self.viewController = viewController
        self.options = options ?? [:]
    }

    func loadToBeVision(_ toBeVision: MyToBeVisionModel.Model) {
        viewController?.setup(with: toBeVision)
    }

    func updateToBeVision(_ toBeVision: MyToBeVisionModel.Model) {
        viewController?.update(with: toBeVision)
    }

    func presentVisionGenerator() {
        viewController?.showVisionGenerator()
    }

    func setLaunchOptions(_ options: [LaunchOption: String?]) {
        viewController?.setLaunchOptions(options)
    }
}
