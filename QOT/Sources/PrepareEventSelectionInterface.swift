//
//  PrepareEventSelectionInterface.swift
//  QOT
//
//  Created by karmic on 27.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol PrepareEventSelectionTableViewCellInterface: class {}

protocol PrepareEventSelectionPresenterInterface {}

protocol PrepareEventSelectionInteractorInterface: Interactor {
    var rowCount: Int { get }
    func event(at indexPath: IndexPath) -> QDMUserCalendarEvent?
    func dateString(for event: QDMUserCalendarEvent?) -> String?
    func didSelect(_ event: QDMUserCalendarEvent)
}

protocol PrepareEventSelectionRouterInterface {
    func didSelectCalendarEvent(_ event: QDMUserCalendarEvent, selectedAnswer: QDMAnswer)
}
