//
//  MyQotAdminDCSixthQuestionSettingsInteractor.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQotAdminDCSixthQuestionSettingsInteractor {

    // MARK: - Properties
    private lazy var worker = MyQotAdminDCSixthQuestionSettingsWorker()
    private let presenter: MyQotAdminDCSixthQuestionSettingsPresenterInterface!

    // MARK: - Init
    init(presenter: MyQotAdminDCSixthQuestionSettingsPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }

    public static func getSixthQuestionPriority(completion: @escaping ([Int]) -> Void) {
        SettingService.main.getSettingFor(key: SettingKey.DailyCheckInSixthQuestionWeight) { (setting, _, _) in
            if let json = setting?.textValue, let jsonData = json.data(using: .utf8) {
                do {
                    let weights = try JSONDecoder().decode(DailyCheckInSixthQuestionWeight.self, from: jsonData)
                    let weekday = (Calendar.current.dateComponents([.weekday], from: Date()).weekday ?? 1)
                    switch weekday {
                    case 2: completion(weights.monday ?? [0, 1, 2])
                    case 3: completion(weights.tuesday ?? [0, 1, 2])
                    case 4: completion(weights.wednesday ?? [0, 1, 2])
                    case 5: completion(weights.thursday ?? [0, 1, 2])
                    case 6: completion(weights.friday ?? [0, 1, 2])
                    case 7: completion(weights.saturday ?? [0, 1, 2])
                    default: completion(weights.sunday ?? [0, 1, 2])
                    }
                } catch {
                    completion([0, 1, 2])
                    print("failed to get DC 6th question settings")
                }
            }
        }
    }

    func setSixthQuestionPriorities(_ priorities: [Int], completion: @escaping () -> Void) {
        SettingService.main.getSettingFor(key: SettingKey.DailyCheckInSixthQuestionWeight) { (setting, _, _) in
            if let json = setting?.textValue, let jsonData = json.data(using: .utf8) {
                do {
                    var weights = try JSONDecoder().decode(DailyCheckInSixthQuestionWeight.self, from: jsonData)
                    let weekday = (Calendar.current.dateComponents([.weekday], from: Date()).weekday ?? 1)

                    switch weekday {
                    case 2: weights.monday = priorities
                    case 3: weights.tuesday = priorities
                    case 4: weights.wednesday = priorities
                    case 5: weights.thursday = priorities
                    case 6: weights.friday = priorities
                    case 7: weights.saturday = priorities
                    default: weights.sunday = priorities
                    }
                    do {
                        if var newSetting = setting {
                            let textValue = try JSONEncoder().encode(weights)
                            newSetting.textValue = String(data: textValue, encoding: .utf8)
                            SettingService.main.updateSetting(newSetting, false) { (_) in
                                completion()
                            }
                        }
                    } catch {
                        print("failed to encode DailyCheckInSixthQuestionWeight")
                    }
                } catch {
                    print("failed to get DC 6th question settings")
                }
            }
        }
    }
}

// MARK: - MyQotAdminDCSixthQuestionSettingsInterface
extension MyQotAdminDCSixthQuestionSettingsInteractor: MyQotAdminDCSixthQuestionSettingsInteractorInterface {
    func getHeaderTitle() -> String {
        return "DAILY CHECKIN 6TH QUESTION"
    }

    func getSetting(at index: Int) -> [Int] {
        return worker.datasource[index]
    }
    
    func getDatasourceCount() -> Int {
        return worker.datasource.count
    }

    func getCurrentSetting() -> [Int] {
        return worker.currentSetting
    }

    func setCurrentSetting(setting: [Int]) {
        worker.currentSetting = setting
    }

    func isSelected(at index: Int) -> Bool {
        return getSetting(at: index) == getCurrentSetting()
    }

    func getTitle(for index: Int) -> String {
        switch index {
        case 0:
            return "TBV - SHPI - PEAK"
        case 1:
            return "TBV - PEAK - SHPI"
        case 2:
            return "SHPI - TBV - PEAK"
        case 3:
            return "SHPI - PEAK - TBV"
        case 4:
            return "PEAK - TBV - SHPI"
        default:
            return "PEAK - SHPI - TBV"
        }
    }

    func selectPriority(at index: Int, completion: @escaping () -> Void) {
        setSixthQuestionPriorities(worker.datasource[index]) {
            completion()
        }
    }
}
