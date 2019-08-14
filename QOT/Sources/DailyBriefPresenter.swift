//
//  DailyBriefPresenter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import DifferenceKit

final class DailyBriefPresenter {

    // MARK: - Properties

    private weak var viewController: DailyBriefViewControllerInterface?

    // MARK: - Init

    init(viewController: DailyBriefViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - DailyBriefInterface

extension DailyBriefPresenter: DailyBriefPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func updateView(_ differenceList: StagedChangeset<[BaseDailyBriefViewModel]>) {
        viewController?.updateView(differenceList)
    }
}
