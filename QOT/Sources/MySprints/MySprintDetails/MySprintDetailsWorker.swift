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
        return R.string.localized.mySprintDetailsButtonCancel()
    }()

    lazy var buttonContinue = {
        return R.string.localized.mySprintDetailsButtonContinue()
    }()

    lazy var buttonStartSprint: String = {
        return R.string.localized.mySprintDetailsButtonStartSprint()
    }()

    lazy var infoPauseSprintTitle: String = {
        return R.string.localized.mySprintDetailsInfoTitlePauseSprint()
    }()

    lazy var infoPauseSprintMessage: String = {
        return R.string.localized.mySprintDetailsInfoMessagePauseSprint(sprint.maxDays)
    }()

    lazy var buttonPauseSprint: String = {
        return R.string.localized.mySprintDetailsButtonPauseSprint()
    }()

    lazy var buttonYesPause: String = {
        return R.string.localized.mySprintDetailsButtonYesPause()
    }()

    lazy var infoReplanSprintTitle: String = {
        return R.string.localized.mySprintDetailsInfoTitleReplanSprint()
    }()

    lazy var infoReplanSprintMessage: String = {
        return R.string.localized.mySprintDetailsInfoMessageReplanSprint(sprint.maxDays)
    }()

    lazy var buttonContinueSprint: String = {
        return R.string.localized.mySprintDetailsButtonContinue()
    }()

    lazy var buttonRestartSprint: String = {
        return R.string.localized.mySprintDetailsButtonRestartSprint()
    }()

    lazy var infoSprintInProgressTitle: String = {
        return R.string.localized.mySprintDetailsInfoTitleSprintInProgress()
    }()

    func infoSprintInProgressMessage(endDate: Date) -> String {
        return R.string.localized.mySprintDetailsInfoMessageSprintInProgress(DateFormatter.ddMMMyyyy.string(from: endDate))
    }

    var sprintStatus: MySprintStatus {
        return MySprintStatus.from(sprint)
    }
}

extension MySprintDetailsWorker {

    func anySprintInProgress(_ completion: @escaping (Bool, Date?) -> Void) {
        service.isSprintAlreadyInProgress { (sprint, date) in
            completion(sprint != nil, date)
        }
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
        service.startSprint(sprint) { [weak self] (sprint, error) in
            self?.updateSprint(sprint, error: error, completion: completion)
        }
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
}
