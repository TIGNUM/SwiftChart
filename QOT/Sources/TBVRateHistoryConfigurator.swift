//
//  TBVRateHistoryConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 04.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class TBVRateHistoryConfigurator {
    static func configure(viewController: MyToBeVisionTrackerViewController, displayType: TBVRateHistory.DisplayType) {
        let presenter = TBVRateHistoryPresenter(viewController: viewController)
        let interactor = TBVRateHistoryInteractor(presenter, displayType)
        viewController.interactor = interactor
    }
}
