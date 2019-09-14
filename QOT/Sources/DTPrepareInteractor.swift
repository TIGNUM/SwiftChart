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

    // MARK: - Properties
    var preparePresenter: DTPreparePresenterInterface?

    // MARK: - DTInteractor
    override func loadNextQuestion(selection: DTSelectionModel) {
        if selection.question?.key == Prepare.QuestionKey.Intro {
            checkCalendarPermissionForSelection(selection)
        } else {
            super.loadNextQuestion(selection: selection)
        }
    }
}

// MARK: - DTPrepareInteractorInterface
extension DTPrepareInteractor: DTPrepareInteractorInterface {
    func setUserCalendarEvent(event: QDMUserCalendarEvent) {

    }
}

// MARK: - Private
private extension DTPrepareInteractor {
    func checkCalendarPermissionForSelection(_ selection: DTSelectionModel) {
        let answerKeys = selection.selectedAnswers.first?.keys ?? []
        if answerKeys.contains(Prepare.AnswerKey.EventTypeSelectionDaily) ||
            answerKeys.contains(Prepare.AnswerKey.EventTypeSelectionCritical) {

            switch CalendarPermission().authorizationStatus {
            case .notDetermined:
                preparePresenter?.presentCalendarPermission(.calendar)
            case .denied, .restricted:
                preparePresenter?.presentCalendarPermission(.calendarOpenSettings)
            default:
                super.loadNextQuestion(selection: selection)
            }
        }
    }
}
