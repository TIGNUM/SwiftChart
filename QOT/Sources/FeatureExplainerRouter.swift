//
//  FeatureExplainerRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 26.05.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class FeatureExplainerRouter {

    // MARK: - Properties
    private weak var viewController: FeatureExplainerViewController?

    // MARK: - Init
    init(viewController: FeatureExplainerViewController?) {
        self.viewController = viewController
    }
}

// MARK: - FeatureExplainerRouterInterface
extension FeatureExplainerRouter: FeatureExplainerRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
