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

    func getDatasourceObject(at index: Int) -> (type: SprintSettingType, property: SprintProperty, value: Any) {
        return worker.datasource[index]
    }
}
