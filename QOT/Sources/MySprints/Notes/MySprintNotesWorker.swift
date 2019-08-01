//
//  MySprintNotesWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 11/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MySprintNotesWorker {

    enum NotesError: Swift.Error {
        case missingNote
    }

    // MARK: - Properties

    private let service = qot_dal.UserService.main
    private var sprint: QDMSprint
    private let action: MySprintDetailsItem.Action

    // MARK: - Init

    init(sprint: QDMSprint, action: MySprintDetailsItem.Action) {
        switch action {
        case .benefits, .highlights, .strategies: break // Valid note editing actions
        case .captureTakeaways: assertionFailure("Invalid sprint note editing action") // Invalid note action
        }
        self.sprint = sprint
        self.action = action
    }

    lazy var text: String? = {
        switch action {
        case .benefits:
            return sprint.notesBenefits
        case .highlights:
            return sprint.notesLearnings
        case .strategies:
            return sprint.notesReflection
        case .captureTakeaways:
            return nil
        }
    }()

    // MARK: Texts

    lazy var title: String = {
        switch action {
        case .benefits:
            return R.string.localized.mySprintDetailsHeaderBenefits()
        case .highlights:
            return R.string.localized.mySprintDetailsHeaderHighlights()
        case .strategies:
            return R.string.localized.mySprintDetailsHeaderStrategies()
        case .captureTakeaways:
            return "-"
        }
    }()

    lazy var saveTitle: String = {
        return R.string.localized.mySprintDetailsNotesButtonSave()
    }()

    lazy var dismissAlertTitle: String = {
        return R.string.localized.mySprintDetailsNotesInfoTitleLeave()
    }()

    lazy var dismissAlertMessage: NSAttributedString = {
        return NSAttributedString(string: R.string.localized.mySprintDetailsNotesInfoMessageLeave())
    }()

    lazy var cancelTitle: String = {
       return R.string.localized.mySprintDetailsNotesButtonCancel()
    }()

    lazy var leaveButtonTitle: String = {
        return R.string.localized.mySprintDetailsNotesButtonLeave()
    }()
}

extension MySprintNotesWorker {

    func saveText(_ text: String?, completion: @escaping (QDMSprint?, Error?) -> Void) {
        var updatedSprint = sprint
        switch action {
        case .benefits:
            updatedSprint.notesBenefits = text
        case .highlights:
            updatedSprint.notesLearnings = text
        case .strategies:
            updatedSprint.notesReflection = text
        case .captureTakeaways:
            return
        }
        service.updateSprint(updatedSprint, completion)
    }
}
