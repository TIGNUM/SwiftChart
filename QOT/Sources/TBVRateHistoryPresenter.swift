//
//  TBVRateHistoryPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 04.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

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
}
