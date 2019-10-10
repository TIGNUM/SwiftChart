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
    case jobTitle
    case email
    case phone
    case firstName
    case lastName
    case dateOfBirth
    case calendar
    case calendarOnOtherDevices
    case tutorial
    case interview
    case support
    case strategies
    case dailyPrep
    case weeklyChoices
    case password
    case logout
    case confirm
    case terms
    case copyrights
    case security
    case adminSettings

    var title: String {
        switch self {
        case .company: return R.string.localized.settingsGeneralCompanyTitle()
        case .jobTitle: return R.string.localized.settingsGeneralJobTitleTitle()
        case .email: return R.string.localized.settingsGeneralEmailTitle()
        case .phone: return R.string.localized.settingsGeneralTelephoneTitle()
        case .firstName: return R.string.localized.settingsGeneralFirstNameTitle()
        case .lastName: return R.string.localized.settingsGeneralLastNameTitle()
        case .dateOfBirth: return R.string.localized.settingsGeneralDateOfBirthTitle()
        case .calendar: return R.string.localized.settingsGeneralCalendarTitle()
        case .calendarOnOtherDevices: return R.string.localized.settingsGeneralCalendarTitle()
        case .tutorial: return R.string.localized.settingsGeneralTutorialTitle()
        case .interview: return R.string.localized.settingsGeneralInterviewTitle()
        case .support: return R.string.localized.settingsGeneralSupportTitle()
        case .strategies: return R.string.localized.settingsNotificationsStrategiesTitle()
        case .dailyPrep: return R.string.localized.settingsNotificationsDailyPrepTitle()
        case .weeklyChoices: return R.string.localized.settingsNotificationsWeeklyChoicesTitle()
        case .password: return R.string.localized.settingsSecurityPasswordTitle()
        case .logout: return AppTextService.get(AppTextKey.my_qot_account_settings_view_logout_button)
        case .confirm: return R.string.localized.settingsSecurityConfirmTitle()
        case .terms: return R.string.localized.settingsSecurityTermsTitle()
        case .copyrights: return R.string.localized.settingsSecurityCopyrightsTitle()
        case .security: return R.string.localized.settingsSecurityPrivacyPolicyTitle()
        case .adminSettings: return R.string.localized.settingsGeneralAdminTitle()
        }
    }

    var valueTextColor: UIColor {
        switch self {
        case .calendar, .calendarOnOtherDevices: return .white40
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
            case .general: return R.string.localized.settingsTitleGeneral()
            case .notifications: return R.string.localized.settingsTitleNotifications()
            case .security: return R.string.localized.settingsTitleSecurity()
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
    case multipleStringPicker(title: String, rows: UserMeasurement, initialSelection: [Index], settingsType: SettingsType)

    var identifier: String {
        switch self {
        case .button: return R.reuseIdentifier.settingsTableViewCell_Button.identifier
        case .control: return R.reuseIdentifier.settingsTableViewCell_Control.identifier
        case .datePicker: return R.reuseIdentifier.settingsTableViewCell_Label.identifier
        case .label: return R.reuseIdentifier.settingsTableViewCell_Label.identifier
        case .stringPicker: return R.reuseIdentifier.settingsTableViewCell_Label.identifier
        case .multipleStringPicker: return R.reuseIdentifier.settingsTableViewCell_Label.identifier
        case .textField: return R.reuseIdentifier.settingsTableViewCell_TextField.identifier
        }
    }
}

struct Sections: SettingsSection {
    let title: String
    let rows: [SettingsRow]
}
