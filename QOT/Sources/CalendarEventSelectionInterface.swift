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
    func showLoadingDots()
}

protocol CalendarEventSelectionPresenterInterface {
    func setupView()
    func showLoadingDots()
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

protocol CalendarEventSelectionDelegate: class {
    func didSelectEvent(_ event: QDMUserCalendarEvent)
    func didCreateEvent(_ event: EKEvent?)
}
