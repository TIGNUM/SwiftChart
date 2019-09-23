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
    private let service = qot_dal.UserService.main
    private let notificationCenter: NotificationCenter

    // MARK: - Init
    public private(set) var sprint: QDMSprint

    init(sprint: QDMSprint, notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.sprint = sprint
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
        guard let startDate = sprint.startDate else {
            return upcomingInfoText
        }
        return R.string.localized.mySprintDetailsInfoTextActive(DateFormatter.ddMMM.string(from: startDate))
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
        return String(format: format, sprint.maxDays)
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
                                          newSprintTitle: self.sprint.title ?? "",
                                          message: message)
    }

    var sprintStatus: MySprintStatus {
        return MySprintStatus.from(sprint)
    }
}

extension MySprintDetailsWorker {

    func isSprintInProgress(_ completion: @escaping (QDMSprint?, Date?) -> Void) {
        qot_dal.UserService.main.isSprintAlreadyInProgress(completion)
    }

    func startSprint(_ completion: @escaping (Error?) -> Void) {
        service.startSprint(sprint) { [weak self] (sprint, error) in
            self?.updateSprint(sprint, error: error, completion: completion)
        }
    }

    func pauseSprint(_ completion: @escaping (Error?) -> Void) {
        service.pauseSprint(sprint) { [weak self] (sprint, error) in
            self?.updateSprint(sprint, error: error, completion: completion)
        }
    }

    func saveUpdatedSprint(_ sprint: QDMSprint, _ completion: @escaping (Error?) -> Void) {
        service.updateSprint(sprint) { [weak self] (sprint, error) in
            self?.updateSprint(sprint, error: error, completion: completion)
        }
    }

    func continueSprint(_ completion: @escaping (Error?) -> Void) {
        service.continueSprint(sprint) { [weak self] (sprint, error) in
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
        }
        notificationCenter.post(name: .didUpdateMySprintsData, object: nil)
        completion(nil)
    }

    func replaceMessagePlaceHolders(sprintInProgressTitle: String, newSprintTitle: String, message: String) -> String {
        let tempMessage = message.replacingOccurrences(of: "[NAME of SPRINT IN PROGRESS]", with: sprintInProgressTitle.uppercased())
        return tempMessage.replacingOccurrences(of: "[NAME OF NEW SPRINT]", with: newSprintTitle.uppercased())
    }
}
