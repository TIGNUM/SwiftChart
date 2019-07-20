//
//  MySprintsListRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MySprintsListRouter {

    // MARK: - Properties

    private let viewController: MySprintsListViewController

    // MARK: - Init

    init(viewController: MySprintsListViewController) {
        self.viewController = viewController
    }
}

// MARK: - MySprintsListRouterInterface

extension MySprintsListRouter: MySprintsListRouterInterface {
    func presentSprint(with sprintId: String) {
        print("Sprint ID: \(sprintId)")
    }
}
