//
//  MyQOTAdminEditSprintsDetailsInteractor.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 19/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQOTAdminEditSprintsDetailsInteractor {

    // MARK: - Properties
    private let sprint: QDMSprint
    private lazy var worker = MyQOTAdminEditSprintsDetailsWorker(sprint: self.sprint)
    private let presenter: MyQOTAdminEditSprintsDetailsPresenterInterface!

    // MARK: - Init
    init(presenter: MyQOTAdminEditSprintsDetailsPresenterInterface, sprint: QDMSprint) {
        self.sprint = sprint
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyQOTAdminEditSprintsDetailsInteractorInterface
extension MyQOTAdminEditSprintsDetailsInteractor: MyQOTAdminEditSprintsDetailsInteractorInterface {
    func getHeaderTitle() -> String {
        return "EDIT SPRINT"
    }

    func getDoneButtonTitle() -> String {
        return AppTextService.get(AppTextKey.daily_brief_daily_check_in_questionnaire_section_footer_button_done)
    }

    func getDatasourceCount() -> Int {
        return worker.datasource.count
    }

    func getDatasourceObject(at index: Int) -> SprintEditObject {
        return worker.datasource[index]
    }

    func getSprint() -> QDMSprint {
        return worker.sprint
    }

    func editSprints(property: SprintEditObject) {
       switch property.property {
       case .nextDay:
            guard let value = property.value as? Date else { return }
            worker.sprint.nextDay = value
       case .startDate:
            guard let value = property.value as? Date else { return }
            worker.sprint.startDate = value
       case .pausedAt:
            guard let value = property.value as? Date else { return }
            worker.sprint.pausedAt = value
       case .completedAt:
            guard let value = property.value as? Date else { return }
            worker.sprint.completedAt = value
       case .title:
            guard let value = property.value as? String else { return }
            worker.sprint.title = value
       case .subtitle:
            guard let value = property.value as? String else { return }
            worker.sprint.subtitle = value
       case .sortOrder:
            guard let value = property.value as? Int else { return }
            worker.sprint.sortOrder = value
       case .currentDay:
            guard let value = property.value as? Int else { return }
            worker.sprint.currentDay = value
       case .notesReflection:
            guard let value = property.value as? String else { return }
            worker.sprint.notesReflection = value
       case .notesLearnings:
            guard let value = property.value as? String else { return }
            worker.sprint.notesLearnings = value
       case .notesBenefits:
            guard let value = property.value as? String else { return }
            worker.sprint.notesBenefits = value
       case .isInProgress:
            guard let value = property.value as? Bool else { return }
            worker.sprint.isInProgress = value
       case .completedDays:
            guard let value = property.value as? Int else { return }
            worker.sprint.completedDays = value
        }
    }

    func updateSprint(completion: @escaping () -> Void) {
        UserService.main.updateSprint(worker.sprint) { (_, _) in
            completion()
        }
    }
}
