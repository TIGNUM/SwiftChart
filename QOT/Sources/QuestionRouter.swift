//
//  QuestionRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 21.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class QuestionRouter {

    // MARK: - Properties

    private let viewController: QuestionViewController

    // MARK: - Init

    init(viewController: QuestionViewController) {
        self.viewController = viewController
    }
}

// MARK: - CoachRouterInterface

extension QuestionRouter: QuestionRouterInterface {
}
