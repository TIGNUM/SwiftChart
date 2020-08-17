//
//  VisionRatingExplanationRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.08.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class VisionRatingExplanationRouter {

    // MARK: - Properties
    private weak var viewController: VisionRatingExplanationViewController?

    // MARK: - Init
    init(viewController: VisionRatingExplanationViewController?) {
        self.viewController = viewController
    }
}

// MARK: - VisionRatingExplanationRouterInterface
extension VisionRatingExplanationRouter: VisionRatingExplanationRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
