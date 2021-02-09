//
//  DailyRemindersPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class DailyRemindersPresenter {

    // MARK: - Properties
    private weak var viewController: DailyRemindersViewControllerInterface?

    // MARK: - Init
    init(viewController: DailyRemindersViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - DailyRemindersInterface
extension DailyRemindersPresenter: DailyRemindersPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func reloadTableView() {
        viewController?.reloadTableView()
    }
}
