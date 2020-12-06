//
//  BaseDailyBriefDetailsPresenter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 09/11/2020.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class BaseDailyBriefDetailsPresenter {

    // MARK: - Properties
    private weak var viewController: BaseDailyBriefDetailsViewControllerInterface?

    // MARK: - Init
    init(viewController: BaseDailyBriefDetailsViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - BaseDailyBriefDetailsInterface
extension BaseDailyBriefDetailsPresenter: BaseDailyBriefDetailsPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func reloadTableView() {
        viewController?.reloadTableView()
    }
}
