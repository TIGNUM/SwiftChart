//
//  DailyRemindersModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

struct DailyRemindersModel {
    let title: String?
    let subtitle: String?
    var children: [ReminderSetting]
    var isOpen: Bool
    var type: ReminderType

    var numberOfRows: Int {
        return isOpen == true ? children.count : 0
    }

    func item(forRow row: Int) -> ReminderSetting? {
        return children.at(index: row)
    }

    mutating func replace(_ item: ReminderSetting, atRow row: Int) {
        children[row] = item
    }

    enum ReminderType: Int {
        case ready = 0
        case morning
        case sleep

        static var allReminders: [ReminderType] {
            return [.ready, .morning, .sleep]
        }
    }
}

struct ReminderSetting {
    var title: String
    var settingValue: String
    var isExpanded: Bool
    var settingType: Setting


    enum Setting: Int {
        case frequency = 0
        case time
        
        static var allSettings: [Setting] {
            return [.frequency, .time]
        }
    }
}
