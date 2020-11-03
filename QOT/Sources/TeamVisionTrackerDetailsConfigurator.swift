//
//  TeamVisionTrackerDetailsConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 28.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class TeamVisionTrackerDetailsConfigurator {
    static func make(report: ToBeVisionReport,
                     sentence: QDMToBeVisionSentence,
                     selectedDate: Date) -> (TeamVisionTrackerDetailsViewController) -> Void {
        return { (viewController) in
            let presenter = TeamVisionTrackerDetailsPresenter(viewController: viewController)
            let interactor = TeamVisionTrackerDetailsInteractor(presenter: presenter,
                                                                report: report,
                                                                sentence: sentence,
                                                                selectedDate: selectedDate)
            viewController.interactor = interactor
        }
    }
}
