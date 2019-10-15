//
//  MySprintsListWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MySprintsListWorker {

    // MARK: - Properties
    private let service = UserService.main
    private var sprints = [QDMSprint]()

    // MARK: - Init

    init() {

    }

    // FIXME: Translate strings
    // MARK: Texts
    lazy var title: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_empty_title)
    }()

    lazy var editingTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_edit_title)
    }()

    lazy var sprintPlanHeader: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_view_title_sprint_plan)
    }()

    lazy var completeHeader: String = {
       return AppTextService.get(AppTextKey.my_qot_my_sprints_view_title_complete)
    }()

    lazy var cancelTitle: String = {
        return AppTextService.get(AppTextKey.generic_view_button_cancel)
    }()

    lazy var removeTitle: String = {
        return AppTextService.get(AppTextKey.generic_view_button_delete)
    }()

    lazy var continueTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_alert_button_continue)
    }()

    lazy var saveTitle: String = {
        return AppTextService.get(AppTextKey.coach_prepare_alert_button_save)
    }()

    lazy var removeItemsAlertTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_alert_title_remove)
    }()

    lazy var removeItemsAlertMessage: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_alert_body_remove)
    }()

    lazy var emptyContentAlertTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_empty_subtitle)
    }()

    lazy var emptyContentAlertMessage: NSAttributedString = {
        return NSAttributedString(string: AppTextService.get(AppTextKey.my_qot_my_sprints_empty_body))
    }()

    lazy var statusActive: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_view_title_active)
    }()

    lazy var statusUpcoming: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_view_title_upcoming)
    }()

    lazy var statusPaused: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_view_title_paused)
    }()

    lazy var statusCompleted: String = {
        return AppTextService.get(AppTextKey.my_qot_my_sprints_view_title_completed_at)
    }()

    func loadData(_ completion: @escaping (_ initiated: Bool, _ sprints: [QDMSprint]) -> Void) {
        sprints.removeAll()
        service.getSprints { [weak self] (sprints, initiated, error) in
            self?.sprints.append(contentsOf: sprints ?? [])
            completion(initiated, sprints ?? [])
        }
    }

    func save(sprints: [QDMSprint], _ completion: @escaping ([QDMSprint]?, Error?) -> Void) {
        service.updateSprints(sprints, completion)
    }

    func remove(sprints: [QDMSprint], _ completion: @escaping (Error?) -> Void) {
        service.deleteSprints(sprints, completion)
    }

    func getSprint(with id: String) -> QDMSprint? {
        return sprints.first(where: { $0.qotId == id })
    }
}
