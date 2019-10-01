//
//  DailyCheckinStartRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 12.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DailyCheckinStartRouter {

    // MARK: - Properties

    private weak var viewController: DailyCheckinStartViewController?

    // MARK: - Init

    init(viewController: DailyCheckinStartViewController) {
        self.viewController = viewController
    }
}

// MARK: - DailyCheckinStartRouterInterface

extension DailyCheckinStartRouter: DailyCheckinStartRouterInterface {
    func showQuestions() {
        guard let viewController = R.storyboard.dailyCheckin.dailyCheckinQuestionsViewController() else { return }
        DailyCheckinQuestionsConfigurator.configure(viewController: viewController)
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
