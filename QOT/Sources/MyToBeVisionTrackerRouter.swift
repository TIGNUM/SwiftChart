//
//  MyToBeVisionTrackerRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 04.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyToBeVisionTrackerRouter {

    // MARK: - Properties

    private let viewController: MyToBeVisionTrackerViewController

    // MARK: - Init

    init(viewController: MyToBeVisionTrackerViewController) {
        self.viewController = viewController
    }
}

// MARK: - MyToBeVisionTrackerRouterInterface

extension MyToBeVisionTrackerRouter: MyToBeVisionTrackerRouterInterface {

}
