//
//  DTSprintWorker.swift
//  QOT
//
//  Created by karmic on 07.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTSprintWorker: DTWorker {}

// MARK: - Sprint
extension DTSprintWorker {
    func addSprintToQueue(sprintContentId: Int) {
        createSprint(sprintContentId) { (sprint) in}
    }

    func isSprintInProgress(_ completion: @escaping (QDMSprint?, Date?) -> Void) {
        qot_dal.UserService.main.isSprintAlreadyInProgress(completion)
    }

    func startSprintTomorrow(selectedSprintContentId: Int) {
        createSprintAndStart(selectedSprintContentId)
    }

    func stopActiveSprintAndStartNewSprint(activeSprint: QDMSprint?, newSprintContentId: Int?) {
        guard let activeSprint = activeSprint, let newSprintContentId = newSprintContentId else { return }
        qot_dal.UserService.main.pauseSprint(activeSprint) { [weak self]  (sprint, error) in
            if let error = error {
                qot_dal.log("Error while trying to pause sprint: \(error.localizedDescription)", level: .error)
            }
            self?.createSprintAndStart(newSprintContentId)
        }
    }

    func updateSprint(_ sprint: QDMSprint?, userInput: String?, questionKey: String) {
        if var tempSprint  = sprint {
            switch questionKey {
            case QuestionKey.SprintReflection.Notes01:
                tempSprint.notesLearnings = userInput
            case QuestionKey.SprintReflection.Notes02:
                tempSprint.notesReflection = userInput
            case QuestionKey.SprintReflection.Notes03:
                tempSprint.notesBenefits = userInput
            default:
                return
            }
            qot_dal.UserService.main.updateSprint(tempSprint) { (sprint, error) in
                if let error = error {
                    qot_dal.log("Error while trying to update spint: \(error.localizedDescription)", level: .error)
                }
                if let sprint = sprint {
                    NotificationCenter.default.post(name: .didUpdateMySprintsData,
                                                    object: nil,
                                                    userInfo: [Notification.Name.MySprintDetailsKeys.sprint: sprint])
                }
            }
        }
    }
}

// MARK: - Private Sprint Managing
private extension DTSprintWorker {
    func createSprintAndStart(_ targetContentId: Int) {
        createSprint(targetContentId) { (sprint) in
            if let sprint = sprint {
                qot_dal.UserService.main.startSprint(sprint) { (sprint, error) in
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
}
