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

    func loadToBeVision() {
        viewController?.setup()
    }

    func updateToBeVision() {
        viewController?.update()
    }

    func presentVisionGenerator() {
        viewController?.showVisionGenerator()
    }

    func setLaunchOptions(_ options: [LaunchOption: String?]) {
        viewController?.setLaunchOptions(options)
    }

    func setLoading() {
        viewController?.setLoading()
    }
}
