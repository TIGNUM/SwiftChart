//
//  PrepareEventSelectionConfigurator.swift
//  QOT
//
//  Created by karmic on 27.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class PrepareEventSelectionConfigurator: AppStateAccess {
    static func make(tableViewCell: CalendarEventsTableViewCell,
                     delegate: DecisionTreeQuestionnaireDelegate?,
                     question: Question) {
        let router = PrepareEventSelectionRouter(tableViewCell: tableViewCell, delegate: delegate)
        let worker = PrepareEventSelectionWorker(services: appState.services, question: question)
        let presenter = PrepareEventSelectionPresenter(tableViewCell: tableViewCell)
        let interactor = PrepareEventSelectionInteractor(worker: worker, presenter: presenter, router: router)
        tableViewCell.interactor = interactor
    }
}
