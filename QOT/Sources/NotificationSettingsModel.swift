//
//  NotificationSettingsModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 03.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit
import qot_dal

struct NotificationSettingsModel {
    let isActive: Bool? = true

    var notificationSettingsCount: Int {
        return Setting.team.rawValue + 1
    }

    enum Setting: Int {
        case dailyReminders = 0
        case sundays
        case peakEvents
        case sprints
        case team

        static var allSettings: [Setting] {
            return [.dailyReminders, .sundays, .peakEvents, .sprints, .team]
        }
    }

    func settingItem(at indexPath: IndexPath) -> Setting {
        return Setting.allSettings.at(index: indexPath.row) ?? .dailyReminders
    }

    private func title(for item: Setting) -> String {
        switch item {
        case .dailyReminders:
            return AppTextService.get(.notification_settings_daily_title)
        case .sundays:
            return AppTextService.get(.notification_settings_sunday_title)
        case .peakEvents:
            return AppTextService.get(.notification_settings_peak_title)
        case .sprints:
            return AppTextService.get(.notification_settings_sprint_title)
        case .team:
            return AppTextService.get(.notification_settings_team_title)
        }
    }

    private func subtitle(for item: Setting) -> String {
        switch item {
        case .dailyReminders:
            return AppTextService.get(.notification_settings_daily_subtitle)
        case .sundays:
            return AppTextService.get(.notification_settings_sunday_subtitle)
        case .peakEvents:
            return AppTextService.get(.notification_settings_peak_subtitle)
        case .sprints:
            return AppTextService.get(.notification_settings_sprint_subtitle)
        case .team:
            return AppTextService.get(.notification_settings_team_subtitle)
        }
    }

//     check status of Notification settings
//    If none are active and one is pressed : Allow Notification settings in phone
//    If only one is active and we deactivate it :  Dont Allow in Notification settings in phone

    func isActive(for item: Setting) -> Bool {
        switch item {
        case .dailyReminders:
            return true
        case .peakEvents:
            return false
        case .sundays:
            return true
        case .sprints:
            return false
        case .team:
            return true
        }
    }

//   func title(for item: Setting) -> String {
//        switch item {
//        case .dailyReminders:
//            return "Daily reminders"
//        case .sundays:
//            return "Sunday insights"
//        case .peakEvents:
//            return "Peak events"
//        case .sprints:
//            return "Sprint follow up"
//        case .team:
//            return "team notifications"
//        }
//    }

//    func subtitle(for item: Setting) -> String {
//        switch item {
//        case .dailyReminders:
//            return "Describe some values and benefits"
//        case .sundays:
//            return "get ready for the week"
//        case .peakEvents:
//            return "be prepared for yourt events"
//        case .sprints:
//            return "sprint related content to support you to achieve your goals"
//        case .team:
//            return "receive notifications related to team functionalities"
//        }
//    }
}
