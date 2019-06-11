//
//  PrepareEventSelectionRouter.swift
//  QOT
//
//  Created by karmic on 27.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class PrepareEventSelectionRouter {

    // MARK: - Properties

    private let tableViewCell: CalendarEventsTableViewCell
    private let delegate: DecisionTreeQuestionnaireDelegate?

    // MARK: - Init

    init(tableViewCell: CalendarEventsTableViewCell,
         delegate: DecisionTreeQuestionnaireDelegate?) {
        self.tableViewCell = tableViewCell
        self.delegate = delegate
    }
}

// MARK: - PrepareEventSelectionRouterInterface

extension PrepareEventSelectionRouter: PrepareEventSelectionRouterInterface {
    func didSelectCalendarEvent(_ event: CalendarEvent, selectedAnswer: Answer) {
        delegate?.didSelectCalendarEvent(event, selectedAnswer: selectedAnswer)
    }
}
