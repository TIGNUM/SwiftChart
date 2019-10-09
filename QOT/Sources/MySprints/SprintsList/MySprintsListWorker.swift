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
        return R.string.localized.mySprintsTitle()
    }()

    lazy var editingTitle: String = {
        return R.string.localized.mySprintsEditTitle()
    }()

    lazy var sprintPlanHeader: String = {
        return R.string.localized.mySprintsSprintPlan()
    }()

    lazy var completeHeader: String = {
       return R.string.localized.mySprintsComplete()
    }()

    lazy var cancelTitle: String = {
        return ScreenTitleService.main.localizedString(for: .ButtonTitleCancel)
    }()

    lazy var removeTitle: String = {
        return R.string.localized.buttonTitleRemove()
    }()

    lazy var continueTitle: String = {
        return AppTextService.get(AppTextKey.generic_alert_continue_button)
    }()

    lazy var saveTitle: String = {
        return AppTextService.get(AppTextKey.coach_prepare_alert_save_button)
    }()

    lazy var removeItemsAlertTitle: String = {
        return R.string.localized.mySprintsAlertRemoveTitle()
    }()

    lazy var removeItemsAlertMessage: String = {
        return R.string.localized.mySprintsAlertRemoveMessage()
    }()

    lazy var emptyContentAlertTitle: String = {
        return R.string.localized.mySprintsAlertEmptyTitle()
    }()

    lazy var emptyContentAlertMessage: NSAttributedString = {
        return NSAttributedString(string: R.string.localized.mySprintsAlertEmptyMessage())
    }()

    lazy var statusActive: String = {
        return R.string.localized.mySprintsStatusActive()
    }()

    lazy var statusUpcoming: String = {
        return R.string.localized.mySprintsStatusUpcoming()
    }()

    lazy var statusPaused: String = {
        return R.string.localized.mySprintsStatusPaused()
    }()

    lazy var statusCompleted: String = {
        return R.string.localized.mySprintsStatusCompleted()
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
