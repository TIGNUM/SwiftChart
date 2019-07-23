//
//  PrepareEventSelectionRouter.swift
//  QOT
//
//  Created by karmic on 27.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class PrepareEventSelectionRouter {

    // MARK: - Properties

    private let tableViewCell: CalendarEventsTableViewCell?
    private let delegate: DecisionTreeQuestionnaireDelegate?

    // MARK: - Init

    init(_ tableViewCell: CalendarEventsTableViewCell?,
         delegate: DecisionTreeQuestionnaireDelegate?) {
        self.tableViewCell = tableViewCell
        self.delegate = delegate
    }
}

// MARK: - PrepareEventSelectionRouterInterface

extension PrepareEventSelectionRouter: PrepareEventSelectionRouterInterface {
    func didSelectCalendarEvent(_ event: QDMUserCalendarEvent, selectedAnswer: QDMAnswer) {
        delegate?.didSelectCalendarEvent(event, selectedAnswer: selectedAnswer)
    }

    func didSelectPreparation(_ event: QDMUserPreparation) {
        delegate?.didSelectPreparation(event)
    }
}
