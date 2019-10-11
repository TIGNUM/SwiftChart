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
        return R.string.localized.mySprintDetailsHeaderSprintTasks()
    }()

    lazy var headerMyPlan: String = {
        return R.string.localized.mySprintDetailsHeaderMyPlan()
    }()

    lazy var headerMyNotes: String = {
        return R.string.localized.mySprintDetailsHeaderMyNotes()
    }()

    lazy var headerHighlights: String = {
        return R.string.localized.mySprintDetailsHeaderHighlights()
    }()

    lazy var headerStrategies: String = {
        return R.string.localized.mySprintDetailsHeaderStrategies()
    }()

    lazy var headerBenefits: String = {
        return R.string.localized.mySprintDetailsHeaderBenefits()
    }()

    lazy var upcomingInfoText: String = {
        return R.string.localized.mySprintDetailsInfoTextUpcoming()
    }()

    lazy var activeInfoText: String = {
        guard let startDate = sprint?.startDate else {
            return upcomingInfoText
        }
        return R.string.localized.mySprintDetailsInfoTextActive()
    }()

    lazy var notesInfoText: String = {
        return R.string.localized.mySprintDetailsInfoTextNotes()
    }()

    lazy var buttonTakeawaysTitle = {
        return R.string.localized.mySprintDetailsButtonTakeaways()
    }()

    lazy var buttonCancel = {
        return ScreenTitleService.main.localizedString(for: .MySprintDetailsButtonCancel)
    }()

    lazy var buttonContinue = {
        return ScreenTitleService.main.localizedString(for: .MySprintDetailsButtonContinue)
    }()

    lazy var buttonStartSprint: String = {
        return R.string.localized.mySprintDetailsButtonStartSprint()
    }()

    lazy var infoPauseSprintTitle: String = {
        return ScreenTitleService.main.localizedString(for: .MySprintDetailsInfoTitlePauseSprint)
    }()

    lazy var infoPauseSprintMessage: String = {
        let format = ScreenTitleService.main.localizedString(for: .MySprintDetailsInfoMessagePauseSprint)
        return String(format: format, sprint?.maxDays ?? 0)
    }()

    lazy var buttonPauseSprint: String = {
        return ScreenTitleService.main.localizedString(for: .MySprintDetailsButtonPauseSprint)
    }()

    lazy var buttonYesPause: String = {
        return ScreenTitleService.main.localizedString(for: .MySprintDetailsButtonContinue)
    }()

    lazy var infoReplanSprintTitle: String = {
        return ScreenTitleService.main.localizedString(for: .MySprintDetailsInfoTitleReplanSprint)
    }()

    lazy var infoReplanSprintMessage: String = {
        return ScreenTitleService.main.localizedString(for: .MySprintDetailsInfoMessageReplanSprint)
    }()

    lazy var buttonContinueSprint: String = {
        return ScreenTitleService.main.localizedString(for: .MySprintDetailsButtonContinueSprint)
    }()

    lazy var buttonRestartSprint: String = {
        return ScreenTitleService.main.localizedString(for: .MySprintDetailsButtonRestartSprint)
    }()

    lazy var infoSprintInProgressTitle: String = {
        return ScreenTitleService.main.localizedString(for: .MySprintDetailsInfoTitleSprintInProgress)
    }()

    func infoSprintInProgressMessage(sprintInProgressTitle: String?) -> String {
        let message = ScreenTitleService.main.localizedString(for: .MySprintDetailsInfoBodyInProgress)
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
