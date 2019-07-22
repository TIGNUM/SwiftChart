//
//  DailyCheckinStartPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 12.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DailyCheckinStartPresenter {

    // MARK: - Properties

    private weak var viewController: DailyCheckinStartViewControllerInterface?

    // MARK: - Init

    init(viewController: DailyCheckinStartViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - DailyCheckinStartInterface

extension DailyCheckinStartPresenter: DailyCheckinStartPresenterInterface {
    func setupView(title: String?, subtitle: String, buttonTitle: String?) {
        viewController?.setupView(title: title, subtitle: subtitle, buttonTitle: buttonTitle)
    }
}
