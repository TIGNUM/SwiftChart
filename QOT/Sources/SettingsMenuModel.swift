//
//  SettingsMenuViewModel.swift
//  QOT
//
//  Created by Sam Wyndham on 13/04/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import qot_dal

enum SettingsType: Int {
    case company = 0
    case email
    case firstName
    case lastName
    case dateOfBirth
    case strategies
    case dailyPrep
    case weeklyChoices
    case password
    case logout
    case confirm
    case terms
    case copyrights
    case security

    var title: String {
        switch self {
        case .company: return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_title_company)
        case .email: return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_title_email)
        case .firstName: return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_title_first_name)
        case .lastName: return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_title_last_name)
        case .dateOfBirth: return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_title_dob)
        case .strategies: return AppTextService.get(AppTextKey.notifications_view_title_strategies)
        case .dailyPrep: return AppTextService.get(AppTextKey.notifications_view_title_daily_prep)
        case .weeklyChoices: return AppTextService.get(AppTextKey.notifications_view_title_weekly_choices)
        case .password: return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_title_security_password)
        case .logout: return AppTextService.get(AppTextKey.my_qot_account_settings_view_button_logout)
        case .confirm: return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_title_security_confirm)
        case .terms: return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_title_terms)
        case .copyrights: return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_title_copyright)
        case .security: return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_title_privacy)
        }
    }

    var valueTextColor: UIColor {
        switch self {
//        case .calendar, .calendarOnOtherDevices: return .white40
        default: return .white
        }
    }

    static func notificationType(key: String) -> SettingsType? {
        if key == SettingsType.strategies.notificationKey {
            return .strategies
        } else if key == SettingsType.dailyPrep.notificationKey {
            return .dailyPrep
        } else if key == SettingsType.weeklyChoices.notificationKey {
            return .weeklyChoices
        }
        return nil
    }

    var notificationKey: String? {
        switch self {
        case .strategies: return "system.notification.strategies"
        case .dailyPrep: return "system.notification.dailyPrep"
        case .weeklyChoices: return "system.notification.weeklyChoices"
        default: return nil
        }
    }

    enum SectionType {
        case general
        case notifications
        case security
        case profile
        case settings

        var title: String {
            switch self {
            case .general: return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_view_title_general)
            case .notifications: return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_view_title_notifications)
            case .security: return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_view_title_security)
            case .profile: return "profile"
            case .settings: return "settings"
            }
        }
    }
}

enum Gender: String {
    case female = "FEMALE"
    case male = "MALE"
    case other = "OTHER"
    case preferNotToSay = "PREFER_NOT_TO_SAY"

    static var allValues: [Gender] {
        return [.female,
                .male,
                .other,
                .preferNotToSay]
    }

    var dsiplayValue: String {
        switch self {
        case .female,
             .male,
             .other: return rawValue.capitalized
        case .preferNotToSay: return rawValue.replacingOccurrences(of: "_", with: " ").capitalized
        }
    }

    static var allValuesAsStrings: [String] {
        return Gender.allValues.map { $0.rawValue }
    }

    var selectedIndex: Index? {
        return Gender.allValuesAsStrings.map({ $0.lowercased() }).index(of: rawValue.lowercased())
    }
}

// MARK: - Form

protocol SettingsSection {
    var title: String { get }
    var rows: [SettingsRow] { get }
}

enum SettingsRow {

    case label(title: String, value: String?, settingsType: SettingsType)
    case stringPicker(title: String, pickerItems: [String], selectedIndex: Index, settingsType: SettingsType)
    case datePicker(title: String, yearOfBirth: String, settingsType: SettingsType)
    case control(title: String, isOn: Bool, settingsType: SettingsType, key: String?, source: String?)
    case button(title: String, value: String, settingsType: SettingsType)
    case textField(title: String, value: String, secure: Bool, settingsType: SettingsType)

    var identifier: String {
        switch self {
        case .button: return R.reuseIdentifier.settingsTableViewCell_Button.identifier
        case .control: return R.reuseIdentifier.settingsTableViewCell_Control.identifier
        case .datePicker: return R.reuseIdentifier.settingsTableViewCell_Label.identifier
        case .label: return R.reuseIdentifier.settingsTableViewCell_Label.identifier
        case .stringPicker: return R.reuseIdentifier.settingsTableViewCell_Label.identifier
        case .textField: return R.reuseIdentifier.settingsTableViewCell_TextField.identifier
        }
    }
}

struct Sections: SettingsSection {
    let title: String
    let rows: [SettingsRow]
}
