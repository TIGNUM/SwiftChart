//
//  DTPrepareInteractor.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTPrepareInteractor: DTInteractor {
    override func loadNextQuestion(selection: DTSelectionModel) {
        if selection.question?.key == Prepare.QuestionKey.Intro {
            if selection.selectedAnswers.first?.keys.contains(Prepare.AnswerKey.EventTypeSelectionDaily) == true ||
                selection.selectedAnswers.first?.keys.contains(Prepare.AnswerKey.EventTypeSelectionCritical) == true {

            }
        } else {
            super.loadNextQuestion(selection: selection)
        }
    }
}

// MARK: - DTPrepareInteractorInterface
extension DTPrepareInteractor: DTPrepareInteractorInterface {
    func checkCalendarPermission() {
        switch CalendarPermission().authorizationStatus {
        case .notDetermined:
//            presenter.openCalendarPermission(.calendar, delegate: self)
        case .denied, .restricted:
//            router.openCalendarPermission(.calendarOpenSettings, delegate: self)
        default:
            return
        }
    }

    func setUserCalendarEvent(event: QDMUserCalendarEvent) {

    }
}
