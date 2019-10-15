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
            return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_title_header_benefits)
        case .highlights:
            return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_title_header_highlights)
        case .strategies:
            return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_title_header_strategies)
        case .captureTakeaways:
            return "-"
        }
    }()

    lazy var saveTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_button_save)
    }()

    lazy var dismissAlertTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_title_leave)
    }()

    lazy var dismissAlertMessage: NSAttributedString = {
        return NSAttributedString(string: AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_body_leave))
    }()

    lazy var cancelTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_button_cancel)
    }()

    lazy var leaveButtonTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_view_button_leave)
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
