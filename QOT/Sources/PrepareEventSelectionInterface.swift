//
//  PrepareEventSelectionInterface.swift
//  QOT
//
//  Created by karmic on 27.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol PrepareEventSelectionTableViewCellInterface: class {}

protocol PrepareEventSelectionPresenterInterface {}

protocol PrepareEventSelectionInteractorInterface: Interactor {
    var rowCount: Int { get }
    func event(at indexPath: IndexPath) -> CalendarEvent?
    func dateString(for event: CalendarEvent?) -> String?
    func didSelect(_ event: CalendarEvent)
}

protocol PrepareEventSelectionRouterInterface {
    func didSelectCalendarEvent(_ event: CalendarEvent, selectedAnswer: Answer)
}
