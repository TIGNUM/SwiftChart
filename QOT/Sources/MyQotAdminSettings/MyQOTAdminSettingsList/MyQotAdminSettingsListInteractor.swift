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

    func getTitleForLocalNotifications() -> String {
        return "Local notifications"
    }

    func getTitleForDCQuestion() -> String {
        return "DC Question #6 priority"
    }

    func getSubtitleForDCQuestion() -> String {
        if worker.currentSixthQuestionSetting == [0, 2, 1] {
            return DailyCheckinQuestionPriorityString.tbvPeakShpi.rawValue
        } else if worker.currentSixthQuestionSetting == [1, 0, 2] {
            return DailyCheckinQuestionPriorityString.shpiTbvPeak.rawValue
        } else if worker.currentSixthQuestionSetting == [1, 2, 0] {
            return DailyCheckinQuestionPriorityString.shpiPeakTbv.rawValue
        } else if worker.currentSixthQuestionSetting == [2, 0, 1] {
            return DailyCheckinQuestionPriorityString.peakTbvShpi.rawValue
        } else if worker.currentSixthQuestionSetting == [2, 1, 0] {
            return DailyCheckinQuestionPriorityString.peakShpiTbv.rawValue
        } else {
            return DailyCheckinQuestionPriorityString.tbvShpiPeak.rawValue
        }
    }

    func getCurrentSixthQuestionSetting() -> [Int] {
        return worker.currentSixthQuestionSetting
    }

    func setCurrentSixthQuestionSetting(setting: [Int]) {
        worker.currentSixthQuestionSetting = setting
    }

    func getTitleForChooseBuckets() -> String {
        return "Choose Daily Brief buckets"
    }

    func getTitleForEditSprints() -> String {
        return "Edit your sprints"
    }
}
