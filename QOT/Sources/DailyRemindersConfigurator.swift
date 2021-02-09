//
//  DailyRemindersConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import Foundation

final class DailyRemindersConfigurator {
    static func make(viewController: DailyRemindersViewController) {
            let presenter = DailyRemindersPresenter(viewController: viewController)
            let interactor = DailyRemindersInteractor(presenter: presenter)
            viewController.interactor = interactor
    }
}
