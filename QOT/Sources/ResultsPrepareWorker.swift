//
//  ResultsPrepareWorker.swift
//  QOT
//
//  Created by karmic on 11.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ResultsPrepareWorker {

    // MARK: - Init
    init() { /**/ }

}

// MARK: - DTViewModel
extension ResultsPrepareWorker {
    func getDTViewModel(_ key: Prepare.Key,
                        preparation: QDMUserPreparation?,
                        _ completion: @escaping (DTViewModel, QDMQuestion?) -> Void) {
        let selectedIds: [Int] = getSelectedIntentionIds(key: key, preparation: preparation)
        QuestionService.main.question(with: key.questionID, in: .Prepare_3_0) { (qdmQuestion) in
            guard let qdmQuestion = qdmQuestion else { return }
            let question = DTViewModel.Question(qdmQuestion: qdmQuestion)
            let filteredAnswers = qdmQuestion.answers.filter { $0.keys.contains(preparation?.answerFilter ?? "") }
            let answers = filteredAnswers.compactMap { DTViewModel.Answer(qdmAnswer: $0, selectedIds: selectedIds) }
            completion(DTViewModel(question: question,
                                   answers: answers,
                                   events: [],
                                   tbvText: nil,
                                   userInputText: preparation?.benefits,
                                   hasTypingAnimation: false,
                                   typingAnimationDuration: 0,
                                   previousButtonIsHidden: true,
                                   dismissButtonIsHidden: false,
                                   showNextQuestionAutomated: false),
                       qdmQuestion)
        }
    }

    func getSelectedIntentionIds(key: Prepare.Key, preparation: QDMUserPreparation?) -> [Int] {
        switch key {
        case .feel: return preparation?.feelAnswerIds ?? []
        case .know: return preparation?.knowAnswerIds ?? []
        case .perceived: return preparation?.preceiveAnswerIds ?? []
        default: return []
        }
    }
}

// MARK: - QDMQuestion
extension ResultsPrepareWorker {
    func getAnswers(answerIds: [Int], key: Prepare.Key, _ completion: @escaping ([QDMAnswer]) -> Void) {
        QuestionService.main.questions(with: key.rawValue) { (questions) in
            completion(questions?.first?.answers.filter { answerIds.contains($0.remoteID ?? 0) } ?? [])
        }
    }

    func getStrategies(_ collectionIds: [Int], _ completion: @escaping ([QDMContentCollection]?) -> Void) {
        ContentService.main.getContentCollectionsByIds(collectionIds, completion)
    }
}

// MARK: - Update, Delete
extension ResultsPrepareWorker {
    func updatePreparation(_ preparation: QDMUserPreparation?,
                           _ event: QDMUserCalendarEvent?,
                           _ completion: @escaping (QDMUserPreparation?) -> Void) {
        guard var preparation = preparation else { return }
        preparation.setReminder = preparation.eventDate != nil && preparation.eventTitle != nil
        UserService.main.updateUserPreparation(preparation, newEvent: event) { (updatedPrep, error) in
            if let error = error {
                log("Error updateUserPreparation \(error.localizedDescription)", level: .error)
            }
            completion(updatedPrep)
        }
    }

    func deletePreparation(_ preparation: QDMUserPreparation?) {
        if let preparation = preparation {
            let externalIdentifier = preparation.eventExternalUniqueIdentifierId?.components(separatedBy: "[//]").first
            WorkerCalendar().deleteLocalEvent(externalIdentifier)
            UserService.main.deleteUserPreparation(preparation) { (error) in
                if let error = error {
                    log("Error deleteUserPreparation \(error.localizedDescription)", level: .error)
                }
            }
        }
    }
}
