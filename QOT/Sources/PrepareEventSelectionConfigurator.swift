//
//  PrepareEventSelectionConfigurator.swift
//  QOT
//
//  Created by karmic on 27.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class PrepareEventSelectionConfigurator {
    static func make(_ tableViewCell: CalendarEventsTableViewCell?,
                     delegate: DecisionTreeQuestionnaireDelegate?,
                     question: QDMQuestion,
                     events: [QDMUserCalendarEvent],
                     preparations: [QDMUserPreparation]) {
        let router = PrepareEventSelectionRouter(tableViewCell, delegate: delegate)
        let worker = PrepareEventSelectionWorker(question: question, events: events, preparations: preparations)
        let presenter = PrepareEventSelectionPresenter(tableViewCell: tableViewCell)
        let interactor = PrepareEventSelectionInteractor(worker: worker, presenter: presenter, router: router)
        tableViewCell?.interactor = interactor
    }
}
