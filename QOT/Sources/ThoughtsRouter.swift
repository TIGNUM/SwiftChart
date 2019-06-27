//
//  ThoughtsRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ThoughtsRouter {

    // MARK: - Properties

    private let viewController: ThoughtsViewController

    // MARK: - Init

    init(viewController: ThoughtsViewController) {
        self.viewController = viewController
    }
}

// MARK: - ThoughtsRouterInterface

extension ThoughtsRouter: ThoughtsRouterInterface {

}
