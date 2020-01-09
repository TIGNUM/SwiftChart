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
        let defaultPriority = dailyCheckinQuestionsPriorities.tbvShpiPeak
        SettingService.main.getSettingFor(key: SettingKey.DailyCheckInSixthQuestionWeight) { (setting, _, _) in
            if let json = setting?.textValue, let jsonData = json.data(using: .utf8) {
                do {
                    let weights = try JSONDecoder().decode(DailyCheckInSixthQuestionWeight.self, from: jsonData)
                    let weekday = (Calendar.current.dateComponents([.weekday], from: Date()).weekday ?? 1)
                    switch weekday {
                    case 2: completion(weights.monday ?? defaultPriority)
                    case 3: completion(weights.tuesday ?? defaultPriority)
                    case 4: completion(weights.wednesday ?? defaultPriority)
                    case 5: completion(weights.thursday ?? defaultPriority)
                    case 6: completion(weights.friday ?? defaultPriority)
                    case 7: completion(weights.saturday ?? defaultPriority)
                    default: completion(weights.sunday ?? defaultPriority)
                    }
                } catch {
                    completion(defaultPriority)
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
            return dailyCheckinQuestionPriorityString.tbvShpiPeak.rawValue
        case 1:
            return dailyCheckinQuestionPriorityString.tbvPeakShpi.rawValue
        case 2:
            return dailyCheckinQuestionPriorityString.shpiTbvPeak.rawValue
        case 3:
            return dailyCheckinQuestionPriorityString.shpiPeakTbv.rawValue
        case 4:
            return dailyCheckinQuestionPriorityString.peakTbvShpi.rawValue
        default:
            return dailyCheckinQuestionPriorityString.peakShpiTbv.rawValue
        }
    }

    func selectPriority(at index: Int, completion: @escaping () -> Void) {
        setSixthQuestionPriorities(worker.datasource[index]) {
            completion()
        }
    }
}
