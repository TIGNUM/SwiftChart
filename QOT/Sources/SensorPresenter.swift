//
//  SensorPresenter.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 17/07/2018.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SensorPresenter {

    // MARK: - Properties

    private weak var viewController: SensorViewControllerInterface?

    // MARK: - Init

    init(viewController: SensorViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SensorInterface

extension SensorPresenter: SensorPresenterInterface {

    func setup(sensors: [SensorModel], headline: String, content: String) {
        viewController?.setup(sensors: sensors, headline: headline, content: content)
    }
}
