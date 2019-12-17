//
//  MyQotAdminDCSixthQuestionSettingsInterface.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyQotAdminDCSixthQuestionSettingsViewControllerInterface: class {
    func setupView()
}

protocol MyQotAdminDCSixthQuestionSettingsPresenterInterface {
    func setupView()
}

protocol MyQotAdminDCSixthQuestionSettingsInteractorInterface: Interactor {
    func getHeaderTitle() -> String
    func getSetting(at index: Int) -> [Int]
    func getDatasourceCount() -> Int
    func getCurrentSetting() -> [Int]
    func setCurrentSetting(setting: [Int])
    func isSelected(at index: Int) -> Bool
    func getTitle(for index: Int) -> String
    func selectPriority(at index: Int, completion: @escaping () -> Void)
}

protocol MyQotAdminDCSixthQuestionSettingsRouterInterface {
    func dismiss()
}
