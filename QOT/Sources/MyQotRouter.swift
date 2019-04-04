//
//  MyQotRouter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotRouter {

    // MARK: - Properties

    private let viewController: MyQotViewController

    // MARK: - Init

    init(viewController: MyQotViewController) {
        self.viewController = viewController
    }
}

// MARK: - MyQotRouterInterface

extension MyQotRouter: MyQotRouterInterface {

}
