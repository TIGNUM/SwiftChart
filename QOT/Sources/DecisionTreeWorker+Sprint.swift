//
//  DecisionTreeWorker+Sprint.swift
//  QOT
//
//  Created by karmic on 16.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

// MARK: - Sprint
extension DecisionTreeWorker {
    func handleSprintScheduling(_ answer: QDMAnswer?) {
        let targetContentId = answer?.targetId(.content) ?? 0
        let targetQuestionId = answer?.targetId(.question) ?? 0
        let answerKey: AnswerKey.Sprint = AnswerKey.Sprint(rawValue: answer?.keys.first ?? "") ?? .addToQueue

        switch answerKey {
        case .addToQueue:
            createSprint(targetContentId) { [weak self] (sprint) in
                self?.showNextQuestion(targetId: targetQuestionId, answer: nil)
            }
        case .startTomorrow:
            isSprintInProgress { [weak self] (sprint, endDate) in
                if let sprint = sprint, let endDate = endDate {
                    self?.activeSprint = sprint
                    self?.newSprintContentId = targetContentId
                    self?.lastSprintQuestionId = targetQuestionId
                    self?.interactor?.presentInfoView(icon: R.image.warning(),
                                                      title: "A Sprint is already in progress",
                                                      text: "Looks like you have a sprint in progress that ends the 14.Jun.2019. It’s important to keep your focus to reach your current sprint goals. Would you like to stop it and start To be vision anchors?")
                } else {
                    self?.createSprintAndStart(targetContentId)
                }
            }
        }
    }

    func stopActiveSprintAndStartNewSprint() {
        guard let activeSprint = activeSprint, let newSprintContentId = newSprintContentId else { return }
        qot_dal.UserService.main.pauseSprint(activeSprint) { [weak self]  (sprint, error) in
            if let error = error {
                qot_dal.log("Error while trying to pause sprint: \(error.localizedDescription)", level: .error)
            }
            self?.createSprintAndStart(newSprintContentId)
            self?.activeSprint = nil
            self?.newSprintContentId = nil
        }
    }

    func updateSprint(_ sprint: QDMSprint?, userInput: String?) {
        if var tempSprint  = sprint {
            switch currentQuestion?.key {
            case QuestionKey.SprintReflection.Notes01:
                tempSprint.notesLearnings = userInput
            case QuestionKey.SprintReflection.Notes02:
                tempSprint.notesReflection = userInput
            case QuestionKey.SprintReflection.Notes03:
                tempSprint.notesBenefits = userInput
            default:
                return
            }
            qot_dal.UserService.main.updateSprint(tempSprint) { [weak self] (sprint, error) in
                self?.sprintToUpdate = sprint
                if let error = error {
                    qot_dal.log("Error while trying to update spint: \(error.localizedDescription)", level: .error)
                }
            }
        }
    }
}

// MARK: - Private Sprint Managing
private extension DecisionTreeWorker {
    func createSprintAndStart(_ targetContentId: Int) {
        createSprint(targetContentId) { [weak self] (sprint) in
            if let sprint = sprint {
                qot_dal.UserService.main.startSprint(sprint) { (sprint, error) in
                    self?.showNextQuestion(targetId: self?.lastSprintQuestionId ?? 0, answer: nil)
                    self?.lastSprintQuestionId = nil
                }
            } else {
                qot_dal.log("Error while trying to create sprint: \(targetContentId)", level: .error)
            }
        }
    }

    func createSprint(_ targetContentId: Int, completion: @escaping (QDMSprint?) -> Void) {
        qot_dal.ContentService.main.getContentCollectionById(targetContentId) { (content) in
            let sprintContentId = content?.remoteID
            let relatedContentIds = content?.relatedContentCollectionIDs
            let title = content?.contentItems.filter { $0.format == .header1 }.first?.valueText
            let subTitle = content?.contentItems.filter { $0.format == .subtitle }.first?.valueText
            let taskItemIds = content?.contentItems.filter { $0.format == .title }.compactMap { $0.remoteID }
            let planItemIds = content?.contentItems.filter { $0.format == .listitem }.compactMap { $0.remoteID }
            qot_dal.UserService.main.createSprint(title: title ?? "",
                                                  subTitle: subTitle ?? "",
                                                  sprintContentId: sprintContentId ?? 0,
                                                  relatedContentIds: relatedContentIds ?? [],
                                                  taskItemIds: taskItemIds ?? [],
                                                  planItemIds: planItemIds ?? []) { (sprint, error) in
                                                    if let error = error {
                                                        qot_dal.log("Error while trying to create sprint: \(error.localizedDescription)", level: .error)
                                                    }
                                                    completion(sprint)
            }
        }
    }

    func isSprintInProgress(_ completion: @escaping (QDMSprint?, Date?) -> Void) {
        qot_dal.UserService.main.isSprintAlreadyInProgress(completion)
    }
}
