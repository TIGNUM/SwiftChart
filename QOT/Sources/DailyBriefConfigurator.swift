//
//  DailyBriefConfigurator.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class DailyBriefConfigurator {
    static func configure(delegate: CoachCollectionViewControllerDelegate?, viewController: DailyBriefViewController) {
        let presenter = DailyBriefPresenter(viewController: viewController)
        let interactor = DailyBriefInteractor(presenter: presenter)
        viewController.interactor = interactor
        viewController.delegate = delegate
    }
}
