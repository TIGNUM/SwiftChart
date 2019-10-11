//
//  MySprintDetailsWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MySprintDetailsWorker {

    // MARK: - Properties
    private let notificationCenter: NotificationCenter

    // MARK: - Init
    private var sprintId: String
    private var sprint: QDMSprint?

    init(sprintId: String, notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.sprintId = sprintId
        self.notificationCenter = notificationCenter
    }

    // MARK: Texts
    lazy var headerSprintTasks: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_sprint_tasks_title)
    }()

    lazy var headerMyPlan: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_my_plan_title)
    }()

    lazy var headerMyNotes: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_my_notes_title)
    }()

    lazy var headerHighlights: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_highlights_title)
    }()

    lazy var headerStrategies: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_strategies_title)
    }()

    lazy var headerBenefits: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_benefits_title)
    }()

    lazy var upcomingInfoText: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_upcoming_body)
    }()

    lazy var activeInfoText: String = {
        guard let startDate = sprint?.startDate else {
            return upcomingInfoText
        }
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_active_body)
    }()

    lazy var notesInfoText: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_notes_body)
    }()

    lazy var buttonTakeawaysTitle = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_takeaways_button)
    }()

    lazy var buttonCancel = {
        return AppTextService.get(AppTextKey.generic_view_cancel_button_title)
    }()

    lazy var buttonContinue = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_continue_button)
    }()

    lazy var buttonStartSprint: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_start_sprint_button)
    }()

    lazy var infoPauseSprintTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_pause_sprint_title)
    }()

    lazy var infoPauseSprintMessage: String = {
        let format = AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_pause_sprint_info_title)
        return String(format: format, sprint?.maxDays ?? 0)
    }()

    lazy var buttonPauseSprint: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_pause_sprint_button)
    }()

    lazy var buttonYesPause: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_yes_pause_button)
    }()

    lazy var infoReplanSprintTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_replan_sprint_title)
    }()

    lazy var infoReplanSprintMessage: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_replan_sprint_info_title)
    }()

    lazy var buttonContinueSprint: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_continue_sprint_button)
    }()

    lazy var buttonRestartSprint: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_restart_sprint_button)
    }()

    lazy var infoSprintInProgressTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_replan_sprint_info_title)
    }()

    func infoSprintInProgressMessage(sprintInProgressTitle: String?) -> String {
        let message = AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_sprint_in_progress_info_title)
        return replaceMessagePlaceHolders(sprintInProgressTitle: sprintInProgressTitle ?? "",
                                          newSprintTitle: self.sprint?.title ?? "",
                                          message: message)
    }

    var sprintStatus: MySprintStatus {
        guard let sprint = sprint else {
            return .upcoming
        }
        return MySprintStatus.from(sprint)
    }

    func getSprint(_ completion: @escaping (QDMSprint?) -> Void) {
        UserService.main.getSprints { [weak self] (sprints, _, error) in
            if let error = error {
                log("Error getSprints: \(error.localizedDescription)", level: .error)
            }
            let sprint = sprints?.filter { $0.qotId == self?.sprintId ?? "" }.first
            self?.sprint = sprint
            completion(sprint)
        }
    }
}

extension MySprintDetailsWorker {

    func isSprintInProgress(_ completion: @escaping (QDMSprint?, Date?) -> Void) {
        UserService.main.isSprintAlreadyInProgress(completion)
    }

    func startSprint(_ completion: @escaping (Error?) -> Void) {
        guard let sprint = sprint else { return }
        // if it is completed sprint. Create new sprint with same content and start the created sprint.
        if sprint.completedAt != nil {
            UserService.main.createSprint(title: sprint.title ?? "",
                                          subTitle: sprint.subtitle ?? "",
                                          sprintContentId: sprint.contentCollectionId ?? 0,
                                          relatedContentIds: sprint.relatedContentIds,
                                          taskItemIds: sprint.taskItems.compactMap({ $0.remoteID }),
                                          planItemIds: sprint.planItems.compactMap({ $0.remoteID })) { (newSprint, error) in
                                            guard let sprintToStart = newSprint, error == nil else {
                                                completion(error)
                                                return
                                            }

                                            UserService.main.startSprint(sprintToStart) { [weak self] (startedSprint, error) in
                                                self?.updateSprint(startedSprint, error: error, completion: completion)
                                            }
            }
        } else {
            UserService.main.startSprint(sprint) { [weak self] (sprint, error) in
                self?.updateSprint(sprint, error: error, completion: completion)
            }
        }
    }

    func pauseSprint(_ completion: @escaping (Error?) -> Void) {
        guard let sprint = sprint else { return }
        UserService.main.pauseSprint(sprint) { [weak self] (sprint, error) in
            self?.updateSprint(sprint, error: error, completion: completion)
        }
    }

    func saveUpdatedSprint(_ sprint: QDMSprint, _ completion: @escaping (Error?) -> Void) {
        UserService.main.updateSprint(sprint) { [weak self] (sprint, error) in
            self?.updateSprint(sprint, error: error, completion: completion)
        }
    }

    func continueSprint(_ completion: @escaping (Error?) -> Void) {
        guard let sprint = sprint else { return }
        UserService.main.continueSprint(sprint) { [weak self] (sprint, error) in
            self?.updateSprint(sprint, error: error, completion: completion)
        }
    }

    func setSprint(_ sprint: QDMSprint) {
        self.sprint = sprint
    }
}

// MARK: - Private methods

extension MySprintDetailsWorker {
    private func updateSprint(_ sprint: QDMSprint?, error: Error?, completion: @escaping (Error?) -> Void) {
        if let error = error {
            completion(error)
            return
        }
        if let sprint = sprint {
            self.sprint = sprint
            self.sprintId = sprint.qotId ?? ""
        }
        notificationCenter.post(name: .didUpdateMySprintsData, object: nil)
        completion(nil)
    }

    func replaceMessagePlaceHolders(sprintInProgressTitle: String, newSprintTitle: String, message: String) -> String {
        let tempMessage = message.replacingOccurrences(of: "[NAME of SPRINT IN PROGRESS]", with: sprintInProgressTitle.uppercased())
        return tempMessage.replacingOccurrences(of: "[NAME OF NEW SPRINT]", with: newSprintTitle.uppercased())
    }
}
