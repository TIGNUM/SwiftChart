//
//  DailyRemindersRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class DailyRemindersRouter {

    // MARK: - Properties
    private weak var viewController: DailyRemindersViewController?

    // MARK: - Init
    init(viewController: DailyRemindersViewController?) {
        self.viewController = viewController
    }
}

// MARK: - DailyRemindersRouterInterface
extension DailyRemindersRouter: DailyRemindersRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
