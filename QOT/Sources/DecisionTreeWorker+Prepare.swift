//
//  DecisionTreeWorker+Prepare.swift
//  QOT
//
//  Created by karmic on 19.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

// MARK: - Prepare DB
extension DecisionTreeWorker {
    func getPreparations(_ completion: @escaping ([QDMUserPreparation]?) -> Void) {
        qot_dal.UserService.main.getUserPreparations { (preparations, _, error) in
            if let error = error {
                qot_dal.log("Error while trying to get preparations: \(error.localizedDescription)", level: .error)
            }
            completion(preparations)
        }
    }
}

// MARK: - Handle Prepare ResultView
extension DecisionTreeWorker {
    func showResultView(for answer: QDMAnswer, contentID: Int) {
        switch currentQuestion?.key {
        case QuestionKey.Prepare.Intro where answer.keys.contains(AnswerKey.Prepare.OpenCheckList):
            interactor?.openPrepareResults(contentID)
        case QuestionKey.Prepare.BenefitsInput:
            createPreparationCritical(answer)
        case QuestionKey.Prepare.EventTypeSelectionDaily:
            createPreparationDaily(answer)
        default:
            interactor?.displayContent(with: contentID)
        }
    }
}

// MARK: - Private Create Prepare
private extension DecisionTreeWorker {
    func createPreparationCritical(_ answer: QDMAnswer) {
        let level = QDMUserPreparation.Level.LEVEL_CRITICAL
        PreparationManager.main.create(level: level,
                                       benefits: interactor?.userInput,
                                       answerFilter: answersFilter(),
                                       contentCollectionId: level.contentID,
                                       relatedStrategyId: targetContentID,
                                       strategyIds: [],
                                       eventType: prepareEventType,
                                       event: selectedEvent) { [weak self] (preparation) in
                                        if let preparation = preparation {
                                            self?.interactor?.openPrepareResults(preparation,
                                                                                 self?.decisionTree?.selectedAnswers ?? [])
                                        }
        }
    }

    func createPreparationDaily(_ answer: QDMAnswer) {
        let level = QDMUserPreparation.Level.LEVEL_DAILY
        PreparationManager.main.create(level: level,
                                       contentCollectionId: level.contentID,
                                       relatedStrategyId: answer.decisions.first?.targetTypeId ?? 0,
                                       eventType: answer.subtitle ?? "",
                                       event: selectedEvent) { [weak self] (preparation) in
                                        if let preparation = preparation {
                                            self?.interactor?.openPrepareResults(preparation,
                                                                                 self?.decisionTree?.selectedAnswers ?? [])
                                        }
        }
    }
}

extension DecisionTreeWorker {
    func getCalendarPermissionType() -> AskPermission.Kind? {
        let authStatus = EKEventStore.authorizationStatus(for: .event)
        switch authStatus {
        case .denied:
            return .calendarOpenSettings
        case .notDetermined:
            return .calendar
        default:
            return nil
        }
    }
}
