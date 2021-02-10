//
//  DailyRemindersWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DailyRemindersWorker {

    // MARK: - Init
    init() { /**/ }

    private var dataModel = [DailyRemindersModel]()

    func generateItems(_ completion: @escaping (() -> Void)) {
        generateData { [weak self] (nodes) in
            self?.dataModel = nodes
            completion()
        }
    }

    func title(for item: DailyRemindersModel.ReminderType) -> String {
         switch item {
         case .ready:
             return "Get ready for your day"
         case .morning:
             return "Morning strategy"
         case .sleep:
             return "Sleep preparation"
         }
     }

//    func title(for item: DailyRemindersModel.ReminderType) -> String {
//         switch item {
//         case .ready:
//            return AppTextService.get(.daily_reminders_settings_ready_title)
//         case .morning:
//            return AppTextService.get(.daily_reminders_settings_morning_title)
//         case .sleep:
//            return AppTextService.get(.daily_reminders_settings_sleep_title)
//         }
//     }

    func subtitle(for item: DailyRemindersModel.ReminderType) -> String {
         switch item {
         case .ready:
             return "Start your day with TIGNUM X"
         case .morning:
             return "Strategies to fit in your morning"
         case .sleep:
             return "Unwind for sleep"
         }
     }

//    func subtitle(for item: DailyRemindersModel.ReminderType) -> String {
//         switch item {
//         case .ready:
//            return AppTextService.get(.daily_reminders_settings_ready_subtitle)
//         case .morning:
//            return AppTextService.get(.daily_reminders_settings_ready_subtitle)
//         case .sleep:
//            return AppTextService.get(.daily_reminders_settings_sleep_subtitle)
//         }
//     }

    func settingTitle(for item: ReminderSetting.Setting) -> String {
        switch item {
        case .frequency:
            return "Frequency"
        case .time:
            return "Reminder Time"
        }
    }

//    func settingTitle(for item: ReminderSetting.Setting) -> String {
//        switch item {
//        case .frequency:
//            return AppTextService.get(.daily_reminders_setting_frequency_title)
//        case .time:
//            return AppTextService.get(.daily_reminders_setting_time_title)
//        }
//    }

    func settingValue(for item: ReminderSetting.Setting) -> String {
        switch item {
        case .frequency:
            return "Weekday"
        case .time:
            return "5:00 am"
        }
    }

//    func settingValue(for item: ReminderSetting.Setting) -> String {
//        switch item {
//        case .frequency:
//            return AppTextService.get(.daily_reminders_setting_frequency_value)
//        case .time:
//            return AppTextService.get(.daily_reminders_setting_time_value)
//        }
//    }

    func isParentNode(atIndexPath indexPath: IndexPath) -> Bool {
        return indexPath.row == 0 // first row in section is always a node
    }

    func isExpandedChild(atIndexPath indexPath: IndexPath) -> Bool {
        guard indexPath.row != 0 else { return false }
        let node = dataModel[indexPath.section]
        let child = node.children[indexPath.row - 1]
        return child.isExpanded
    }

    func node(in section: Int) -> DailyRemindersModel {
        return dataModel[section]
    }

    func setIsOpen(_ isOpen: Bool, in section: Int) {
        var node = dataModel[section]
        node.isOpen = isOpen
        dataModel[section] = node
    }

    func setIsExpanded(_ isExpanded: Bool, in indexPath: IndexPath) {
        let node = dataModel[indexPath.section]
        var child = node.children[indexPath.row - 1]
        child.isExpanded = isExpanded
        dataModel[indexPath.section].children[indexPath.row - 1] = child
    }

    func generateData(_ completion: @escaping([DailyRemindersModel]) -> Void) {
        var nodes: [DailyRemindersModel] = []
        var children: [ReminderSetting] = []
        ReminderSetting.Setting.allSettings.forEach { (setting) in
            children.append(ReminderSetting(title: settingTitle(for: setting),
                                            settingValue: settingValue(for: setting),
                                            isExpanded: false,
                                            settingType: setting))
        }
        DailyRemindersModel.ReminderType.allReminders.forEach {(type) in
            nodes.append(DailyRemindersModel(title: title(for: type), subtitle: subtitle(for: type), children: children, isOpen: false, type: type)
        )}
        completion(nodes)
    }

    func item(at indexPath: IndexPath) -> ReminderSetting {
        let node = dataModel[indexPath.section]
        let item = node.children[indexPath.row - 1] // 1 needed for node row, so offset
        return item
    }

    var sectionCount: Int {
        return dataModel.count
    }

    func numberOfRows(in section: Int) -> Int {
        return 1 + dataModel[section].numberOfRows // 1 needed for node row
    }

    var headerTitle: String {
        return "Daily reminders and reflections"
    }
}
