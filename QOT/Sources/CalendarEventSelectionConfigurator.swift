//
//  CalendarEventSelectionConfigurator.swift
//  QOT
//
//  Created by karmic on 06.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

final class CalendarEventSelectionConfigurator {
    static func make(delegate: CalendarEventSelectionDelegate) -> (CalendarEventSelectionViewController) -> Void {
        return { (viewController) in
            let presenter = CalendarEventSelectionPresenter(viewController: viewController)
            let interactor = CalendarEventSelectionInteractor(presenter: presenter)
            viewController.interactor = interactor
            viewController.delegate = delegate
        }
    }
}
