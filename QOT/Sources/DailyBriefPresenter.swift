//
//  DailyBriefPresenter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

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
  
}
