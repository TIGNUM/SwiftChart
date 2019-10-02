//
//  DailyCheckinQuestionsRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 16.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DailyCheckinQuestionsRouter {

    // MARK: - Properties

    private weak var viewController: DailyCheckinQuestionsViewController?

    // MARK: - Init

    init(viewController: DailyCheckinQuestionsViewController) {
        self.viewController = viewController
    }
}

// MARK: - DailyCheckinQuestionsRouterInterface

extension DailyCheckinQuestionsRouter: DailyCheckinQuestionsRouterInterface {

    func dismiss() {
        viewController?.navigationController?.dismiss(animated: true, completion: nil)
    }
}
