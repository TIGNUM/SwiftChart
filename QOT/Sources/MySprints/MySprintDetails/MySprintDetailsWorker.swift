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
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_section_sprint_tasks_title_sprint_tasks)
    }()

    lazy var headerMyPlan: String = {
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_section_my_plan_title_my_plan)
    }()

    lazy var headerMyNotes: String = {
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_section_takeaways_title_my_notes)
    }()

    lazy var headerHighlights: String = {
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_section_takeaways_title_highlights)
    }()

    lazy var headerStrategies: String = {
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_section_takeaways_title_strategies)
    }()

    lazy var headerBenefits: String = {
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_section_takeaways_title_benefits)
    }()

    lazy var upcomingInfoText: String = {
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_null_state_body_upcoming)
    }()

    lazy var activeInfoText: String = {
        guard let startDate = sprint?.startDate else {
            return upcomingInfoText
        }
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_null_state_body_active)
    }()

    lazy var notesInfoText: String = {
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_section_takeaways_body_notes)
    }()

    lazy var buttonTakeawaysTitle = {
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_section_takeaways_button_capture_takeaways)
    }()

    lazy var buttonCancel = {
        return AppTextService.get(.generic_view_button_cancel)
    }()

    lazy var buttonContinue = {
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_alert_pause_sprint_button_continue_sprint)
    }()

    lazy var buttonStartSprint: String = {
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_section_footer_button_start_sprint)
    }()

    lazy var infoPauseSprintTitle: String = {
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_alert_pause_sprint_title)
    }()

    lazy var infoPauseSprintMessage: String = {
        let format = AppTextService.get(.my_qot_my_sprints_my_sprint_details_alert_pause_sprint_body)
        return String(format: format, sprint?.maxDays ?? .zero)
    }()

    lazy var buttonPauseSprint: String = {
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_section_footer_button_pause_sprint)
    }()

    lazy var infoReplanSprintTitle: String = {
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_alert_resume_sprint_title_replan_sprint)
    }()

    lazy var infoReplanSprintMessage: String = {
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_alert_resume_sprint_body)
    }()

    lazy var buttonContinueSprint: String = {
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_section_footer_button_continue_sprint)
    }()

    lazy var buttonRestartSprint: String = {
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_alert_resume_sprint_button_restart_sprint)
    }()

    lazy var infoSprintInProgressTitle: String = {
        return AppTextService.get(.my_qot_my_sprints_my_sprint_details_alert_resume_sprint_body)
    }()

    func infoSprintInProgressMessage(sprintInProgressTitle: String?) -> String {
        let message = AppTextService.get(.my_qot_my_sprints_my_sprint_details_alert_sprint_in_progress_body)
        return replaceMessagePlaceHolders(sprintInProgressTitle: sprintInProgressTitle ?? String.empty,
                                          newSprintTitle: self.sprint?.title ?? String.empty,
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
            let sprint = sprints?.filter { $0.qotId == self?.sprintId ?? String.empty }.first
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
            var model = CreateSprintModel()
            model.sprintContentId = sprint.contentCollectionId ?? .zero
            model.relatedContentIds = sprint.relatedContentIds
            model.title = sprint.title ?? String.empty
            model.subTitle = sprint.subtitle ?? String.empty
            model.taskItemIds = sprint.taskItems.compactMap({ $0.remoteID })
            model.planItemIds = sprint.planItems.compactMap({ $0.remoteID })
            UserService.main.createSprint(data: model) { (newSprint, error) in
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
            self.sprintId = sprint.qotId ?? String.empty
        }
        notificationCenter.post(name: .didUpdateMySprintsData, object: nil)
        completion(nil)
    }

    func replaceMessagePlaceHolders(sprintInProgressTitle: String, newSprintTitle: String, message: String) -> String {
        let tempMessage = message.replacingOccurrences(of: "[NAME of SPRINT IN PROGRESS]", with: sprintInProgressTitle.uppercased())
        return tempMessage.replacingOccurrences(of: "[NAME OF NEW SPRINT]", with: newSprintTitle.uppercased())
    }
}
