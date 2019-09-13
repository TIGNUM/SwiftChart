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
    case gender
    case dateOfBirth
    case weight
    case height
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
        case .gender: return R.string.localized.settingsGeneralGenderTitle()
        case .dateOfBirth: return R.string.localized.settingsGeneralDateOfBirthTitle()
        case .weight: return R.string.localized.settingsGeneralWeightTitle()
        case .height: return R.string.localized.settingsGeneralHeightTitle()
        case .calendar: return R.string.localized.settingsGeneralCalendarTitle()
        case .calendarOnOtherDevices: return R.string.localized.settingsGeneralCalendarTitle()
        case .tutorial: return R.string.localized.settingsGeneralTutorialTitle()
        case .interview: return R.string.localized.settingsGeneralInterviewTitle()
        case .support: return R.string.localized.settingsGeneralSupportTitle()
        case .strategies: return R.string.localized.settingsNotificationsStrategiesTitle()
        case .dailyPrep: return R.string.localized.settingsNotificationsDailyPrepTitle()
        case .weeklyChoices: return R.string.localized.settingsNotificationsWeeklyChoicesTitle()
        case .password: return R.string.localized.settingsSecurityPasswordTitle()
        case .logout: return R.string.localized.sidebarTitleLogout()
        case .confirm: return R.string.localized.settingsSecurityConfirmTitle()
        case .terms: return R.string.localized.settingsSecurityTermsTitle()
        case .copyrights: return R.string.localized.settingsSecurityCopyrightsTitle()
        case .security: return R.string.localized.settingsSecurityPrivacyPolicyTitle()
        case .adminSettings: return R.string.localized.settingsGeneralAdminTitle()
        }
    }

    var valueTextColor: UIColor {
        switch self {
        case .company: return .white
        case .jobTitle: return .white
        case .email: return .white
        case .phone: return .white
        case .firstName: return .white
        case .lastName: return .white
        case .gender: return .white
        case .dateOfBirth: return .white
        case .weight: return .white
        case .height: return .white
        case .calendar: return .white40
        case .calendarOnOtherDevices: return .white40
        case .tutorial: return .white
        case .interview: return .white
        case .support: return .white
        case .strategies: return .white
        case .dailyPrep: return .white
        case .weeklyChoices: return .white
        case .password: return .white
        case .logout: return .white
        case .confirm: return .white
        case .terms: return .white
        case .copyrights: return .white
        case .security: return .white
        case .adminSettings: return .white
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
