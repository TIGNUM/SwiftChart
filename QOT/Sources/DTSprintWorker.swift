//
//  DTSprintWorker.swift
//  QOT
//
//  Created by karmic on 07.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal
import UserNotifications

final class DTSprintWorker: DTWorker {
    enum NotificationAction {
        case none
        case settings
        case permission
    }
    var isPresentedFromCoach: Bool = true
}

// MARK: - Sprint
extension DTSprintWorker {
    func addSprintToQueue(sprintContentId: Int) {
        createSprint(sprintContentId) { (sprint) in}
    }

    func isSprintInProgress(_ completion: @escaping (QDMSprint?, Date?) -> Void) {
        UserService.main.isSprintAlreadyInProgress(completion)
    }

    func startSprintTomorrow(selectedSprintContentId: Int) {
        createSprintAndStart(selectedSprintContentId)
    }

    func stopActiveSprintAndStartNewSprint(activeSprint: QDMSprint?, newSprintContentId: Int?) {
        guard let activeSprint = activeSprint, let newSprintContentId = newSprintContentId else { return }
        UserService.main.pauseSprint(activeSprint) { [weak self]  (sprint, error) in
            if let error = error {
                log("Error while trying to pause sprint: \(error.localizedDescription)", level: .error)
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
            UserService.main.updateSprint(tempSprint) { (sprint, error) in
                if let error = error {
                    log("Error while trying to update spint: \(error.localizedDescription)", level: .error)
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

// MARK: - Notifications
extension DTSprintWorker {
    func checkNotificationPermissions(_ completion: @escaping ((NotificationAction) -> Void)) {
        RemoteNotificationPermission().authorizationStatus { (status) in
            switch status {
            case .denied:
                completion(.settings)
            case .notDetermined:
                completion(.permission)
            case .authorized, .provisional:
                completion(.none)
            }
        }
    }
}

// MARK: - Private Sprint Managing
private extension DTSprintWorker {
    func createSprintAndStart(_ targetContentId: Int) {
        createSprint(targetContentId) { (sprint) in
            if let sprint = sprint {
                UserService.main.startSprint(sprint) { (sprint, error) in
                }
            } else {
                log("Error while trying to create sprint: \(targetContentId)", level: .error)
            }
        }
    }

    func createSprint(_ targetContentId: Int, completion: @escaping (QDMSprint?) -> Void) {
        ContentService.main.getContentCollectionById(targetContentId) { (content) in
            let sprintContentId = content?.remoteID
            let relatedContentIds = content?.relatedContentCollectionIDs
            let title = content?.contentItems.filter { $0.format == .header1 }.first?.valueText
            let subTitle = content?.contentItems.filter { $0.format == .subtitle }.first?.valueText
            let taskItemIds = content?.contentItems.filter { $0.format == .title }.compactMap { $0.remoteID }
            let planItemIds = content?.contentItems.filter { $0.format == .listitem }.compactMap { $0.remoteID }
            UserService.main.createSprint(title: title ?? "",
                                                  subTitle: subTitle ?? "",
                                                  sprintContentId: sprintContentId ?? 0,
                                                  relatedContentIds: relatedContentIds ?? [],
                                                  taskItemIds: taskItemIds ?? [],
                                                  planItemIds: planItemIds ?? []) { (sprint, error) in
                                                    if let error = error {
                                                        log("Error while trying to create sprint: \(error.localizedDescription)", level: .error)
                                                    }
                                                    completion(sprint)
            }
        }
    }
}
