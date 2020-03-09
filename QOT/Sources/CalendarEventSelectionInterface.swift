//
//  CalendarEventSelectionInterface.swift
//  QOT
//
//  Created by karmic on 06.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol CalendarEventSelectionViewControllerInterface: class {
    func setupView()
}

protocol CalendarEventSelectionPresenterInterface {
    func setupView()
}

protocol CalendarEventSelectionInteractorInterface: Interactor {
    var rowCount: Int { get }
    var rightBarItemTitle: String { get }
    func event(at row: Int) -> CalendarEvent?
    func didSelectPreparationEvent(at row: Int)
    func getCalendarIds() -> [String]
}

protocol CalendarEventSelectionRouterInterface {
    func dismiss()
    func presentEditEventController(_ calendarToggleIdentifiers: [String])
}
