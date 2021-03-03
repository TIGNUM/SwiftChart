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
        createSprint(sprintContentId) { (_) in}
    }

    func isSprintInProgress(_ completion: @escaping (QDMSprint?, Date?) -> Void) {
        UserService.main.isSprintAlreadyInProgress(completion)
    }

    func startSprintTomorrow(selectedSprintContentId: Int, completion: @escaping (QDMSprint?) -> Void) {
        createSprintAndStart(selectedSprintContentId, completion: completion)
    }

    func stopActiveSprintAndStartNewSprint(activeSprint: QDMSprint?, newSprintContentId: Int?, completion: @escaping (QDMSprint?) -> Void) {
        guard let activeSprint = activeSprint, let newSprintContentId = newSprintContentId else { return }
        UserService.main.pauseSprint(activeSprint) { [weak self]  (_, error) in
            if let error = error {
                log("Error while trying to pause sprint: \(error.localizedDescription)", level: .error)
            }
            self?.createSprintAndStart(newSprintContentId, completion: completion)
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

    func getUpdatedTitle(contentId: Int, completion: @escaping (String?) -> Void) {
        ContentService.main.getContentCollectionById(contentId) { (content) in
            let filteredItems = content?.contentItems.filter { $0.searchTags.contains(obj: "sprint_task_day_") }
            var result = String.empty
            filteredItems?.compactMap { $0.valueText }.forEach { (title) in
                result.append(title)
            }
            completion(result)
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
            case .authorized, .provisional:
                completion(.none)
            default:
                completion(.permission)
            }
        }
    }
}

// MARK: - Private Sprint Managing
private extension DTSprintWorker {
    func createSprintAndStart(_ targetContentId: Int, completion: @escaping (QDMSprint?) -> Void) {
        createSprint(targetContentId) { (sprint) in
            if let sprint = sprint {
                UserService.main.startSprint(sprint) { (sprint, _) in
                    completion(sprint)
                }
            } else {
                log("Error while trying to create sprint: \(targetContentId)", level: .error)
            }
        }
    }

    func createSprint(_ targetContentId: Int, completion: @escaping (QDMSprint?) -> Void) {
        ContentService.main.getContentCollectionById(targetContentId) { (content) in
            var model = CreateSprintModel()
            model.sprintContentId = content?.remoteID ?? .zero
            model.relatedContentIds = content?.relatedContentCollectionIDs ?? [Int]()
            model.title = content?.contentItems.filter { $0.format == .header1 }.first?.valueText ?? String.empty
            model.subTitle = content?.contentItems.filter { $0.format == .subtitle }.first?.valueText ?? String.empty
            model.taskItemIds = content?.contentItems.filter { $0.format == .title }.compactMap { $0.remoteID } ?? []
            model.planItemIds = content?.contentItems.filter { $0.format == .listitem }.compactMap { $0.remoteID } ?? []
            UserService.main.createSprint(data: model) { (sprint, _) in
                completion(sprint)
            }
        }
    }
}
