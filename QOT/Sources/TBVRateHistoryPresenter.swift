//
//  TBVRateHistoryPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 04.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TBVRateHistoryPresenter {

    // MARK: - Properties
    private weak var viewController: TBVRateHistoryViewControllerInterface?

    // MARK: - Init
    init(viewController: TBVRateHistoryViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - MyToBeVisionTrackerInterface
extension TBVRateHistoryPresenter: TBVRateHistoryPresenterInterface {
    func setupView(with data: ToBeVisionReport) {
        viewController?.setupView(with: data)
    }

    func showErrorNoReportAvailable() {
        viewController?.showErrorNoReportAvailable(title: AppTextService.get(.my_x_tbv_rate_history_title),
                                                   message: AppTextService.get(.my_x_tbv_rate_history_message))
    }
}
