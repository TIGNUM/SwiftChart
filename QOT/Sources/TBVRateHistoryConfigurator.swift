//
//  TBVRateHistoryConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 04.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class TBVRateHistoryConfigurator {
    static func configure(viewController: MyToBeVisionTrackerViewController,
                          displayType: TBVGraph.DisplayType,
                          team: QDMTeam?) {
        let presenter = TBVRateHistoryPresenter(viewController: viewController)
        let interactor = TBVRateHistoryInteractor(presenter, displayType, team)
        viewController.interactor = interactor
    }
}
