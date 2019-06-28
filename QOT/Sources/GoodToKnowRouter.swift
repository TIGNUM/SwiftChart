//
//  GoodToKnowRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 25.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class GoodToKnowRouter {

    // MARK: - Properties

    private let viewController: GoodToKnowViewController

    // MARK: - Init

    init(viewController: GoodToKnowViewController) {
        self.viewController = viewController
    }
}

// MARK: - ThoughtsRouterInterface

extension GoodToKnowRouter: GoodToKnowRouterInterface {

}
