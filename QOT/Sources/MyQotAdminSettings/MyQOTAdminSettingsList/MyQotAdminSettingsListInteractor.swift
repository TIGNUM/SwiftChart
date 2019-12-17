//
//  MyQotAdminSettingsListInteractor.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQotAdminSettingsListInteractor {

    // MARK: - Properties
    private lazy var worker = MyQotAdminSettingsListWorker()
    private let presenter: MyQotAdminSettingsListPresenterInterface!

    // MARK: - Init
    init(presenter: MyQotAdminSettingsListPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyQotAdminSettingsListInteractorInterface
extension MyQotAdminSettingsListInteractor: MyQotAdminSettingsListInteractorInterface {
    func getHeaderTitle() -> String {
        return "ADMIN SETTINGS"
    }

    func getTitleForEnvironmentSettings() -> String {
        return "Environment settings"
    }

    func getSubtitleForEnvironmentSettings() -> String {
        var environment = "PRODUCTION"
        if NetworkRequestManager.main.getCurrentEnvironment() == .development {
            environment = "STAGING"
        }
        return environment
    }

    func getTitleForLocalNotifications() -> String {
        return "Local notifications"
    }

    func getTitleForDCQuestion() -> String {
        return "DC Question #6 priority"
    }

    func getSubtitleForDCQuestion() -> String {
        if worker.currentSixthQuestionSetting == [0, 2, 1] {
            return "TBV - PEAK - SHPI"
        } else if worker.currentSixthQuestionSetting == [1, 0, 2] {
            return "SHPI - TBV - PEAK"
        } else if worker.currentSixthQuestionSetting == [1, 2, 0] {
            return "SHPI - PEAK - TBV"
        } else if worker.currentSixthQuestionSetting == [2, 0, 1] {
            return "PEAK - TBV - SHPI"
        } else if worker.currentSixthQuestionSetting == [2, 1, 0] {
            return "PEAK - SHPI - TBV"
        } else {
            return "TBV - SHPI - PEAK"
        }
    }

    func getCurrentSixthQuestionSetting() -> [Int] {
        return worker.currentSixthQuestionSetting
    }

    func setCurrentSixthQuestionSetting(setting: [Int]) {
        worker.currentSixthQuestionSetting = setting
    }
}
