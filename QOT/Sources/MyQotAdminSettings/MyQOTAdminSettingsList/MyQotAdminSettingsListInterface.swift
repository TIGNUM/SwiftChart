//
//  MyQotAdminSettingsListInterface.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyQotAdminSettingsListViewControllerInterface: class {
    func setupView()
}

protocol MyQotAdminSettingsListPresenterInterface {
    func setupView()
}

protocol MyQotAdminSettingsListInteractorInterface: Interactor {
    func getHeaderTitle() -> String
    func getTitleForEnvironmentSettings() -> String
    func getSubtitleForEnvironmentSettings() -> String
    func getTitleForLocalNotifications() -> String
    func getTitleForDCQuestion() -> String
    func getSubtitleForDCQuestion() -> String
    func getCurrentSixthQuestionSetting() -> [Int]
    func setCurrentSixthQuestionSetting(setting: [Int])
    func getTitleForChooseBuckets() -> String
    func getTitleForEditSprints() -> String
}

protocol MyQotAdminSettingsListRouterInterface {
    func dismiss()
}
