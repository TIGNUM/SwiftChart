//
//  SettingsViewModel.swift
//  QOT
//
//  Created by Sam Wyndham on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

enum Gender: String {
    case female
    case male
    case neutral
    case unkown

    static var allValues: [Gender] {
        return [
            .female,
            .male,
            .neutral,
            .unkown
        ]
    }

    static var allValuesAsStrings: [String] {
        return Gender.allValues.map { $0.rawValue.capitalized }
    }

    var selectedIndex: Index? {
        return Gender.allValuesAsStrings.map({ $0.lowercased() }).index(of: self.rawValue.lowercased())
    }
}

enum PersonalData {
    case weight
    case height

    var title: String {
        switch self {
        case .height: return "Height"
        case .weight: return "Weight"
        }
    }

    var pickerItems: [[String]] {
        switch self {
        case .weight: return []
        case .height: return []
        }
    }

    func selectedIndex(user: User) -> Index {
        switch self {
        case .weight: return selectedIndex(value: user.weight.value)
        case .height: return selectedIndex(value: user.height.value)
        }
    }

    func selectedUnitIndex(user: User) -> Index {
        switch self {
        case .weight: return selectedUnitIndex(unit: user.weightUnit, units: user.weightUnitItems)
        case .height: return selectedUnitIndex(unit: user.heightUnit, units: user.heightUnitItems)
        }
    }

    private var items: [String] {
        var items = [String]()
        for weight in 0...634 {
            items.append(String(format: "%d.0", weight))
        }

        return items
    }

    private func selectedIndex(value: Double?) -> Index {
        var index = 0
        if let value = value {
            index = items.index(of: "\(value)") ?? 0
        }

        return index
    }

    private func selectedUnitIndex(unit: String?, units: [String]) -> Index {
        var index = 0
        if let unit = unit {
            index = units.index(of: unit) ?? 0
        }

        return index
    }
}

final class SettingsViewModel {

    enum SettingsType {
        case general
        case notifications
        case security

        var title: String {
            switch self {
            case .general: return R.string.localized.settingsTitleGeneral()
            case .notifications: return R.string.localized.settingsTitleNotifications()
            case .security: return R.string.localized.settingsTitleSecurity()
            }
        }
    }

    // MARK: - Properties

    fileprivate var settingsSections = [SettingsSection]()
    fileprivate let services: Services
    fileprivate let user: User
    let settingsType: SettingsType
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var sectionCount: Int {
        return settingsSections.count
    }

    func numberOfItemsInSection(in section: Int) -> Int {
        return items(in: section).count
    }

    func row(at indexPath: IndexPath) -> SettingsRow {
        return items(in: indexPath.section)[indexPath.row]
    }

    func headerTitle(in section: Int) -> String {
        return settingsSections[section].title
    }

    func updateDateOfBirth(dateOfBirth: String) {
        services.userService.updateUserDateOfBirth(user: user, dateOfBirth: dateOfBirth)
    }

    func updateGender(gender: String) {
        services.userService.updateUserGender(user: user, gender: gender)
    }

    func updateHeight(height: String) {
        let userHeight = (height.replacingOccurrences(of: ",", with: ".") as NSString).doubleValue
        services.userService.updateUserHeight(user: user, height: userHeight)
    }

    func updateWeight(weight: String) {
        let userWeight = (weight.replacingOccurrences(of: ",", with: ".") as NSString).doubleValue
        services.userService.updateUserWeight(user: user, weight: userWeight)
    }

    func updateWeightUnit(weightUnit: String) {
        services.userService.updateUserWeightUnit(user: user, weightUnit: weightUnit)
    }

    func updateHeightUnit(heightUnit: String) {
        services.userService.updateUserHeightUnit(user: user, heightUnit: heightUnit)
    }

    private func items(in section: Int) -> [SettingsRow] {
        return settingsSections[section].rows
    }

    private func settingSections(user: User?, settingsType: SettingsViewModel.SettingsType) -> [SettingsSection] {
        switch settingsType {
        case .general: return generalSettingsSection(for: user)
        case .notifications: return notificationsSettingsSection
        case .security: return securitySettingsSection
        }
    }

    // MARK: - Init
    
    init?(services: Services, settingsType: SettingsType) {
        self.services = services

        guard let user = services.userService.user() else {
            return nil
        }

        self.user = user
        self.settingsType = settingsType
        self.settingsSections = settingSections(user: user, settingsType: settingsType)
    }
}

protocol SettingsSection {
    var title: String { get }
    var rows: [SettingsRow] { get }
}

enum SettingsRow {
    case label(title: String, value: String?)
    case stringPicker(title: String, pickerItems: [String], selectedIndex: Index)
    case multipleStringPicker(title: String, rows: [[String]], initialSelection: [Index])
    case datePicker(title: String, selectedDate: Date)
    case control(title: String, isOn: Bool)
    case button(title: String, value: String)
    case textField(title: String, value: String, secure: Bool)

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

struct MockSettingsSection: SettingsSection {
    let title: String
    let rows: [SettingsRow]
}

private var securitySettingsSection: [SettingsSection] {
    return [
        MockSettingsSection(title: "Account", rows: accountRows),
        MockSettingsSection(title: "About", rows: aboutRows)
    ]
}

private var notificationsSettingsSection: [SettingsSection] {
    return [
        MockSettingsSection(title: "Categories", rows: categoryNotifications),
        MockSettingsSection(title: "Reminder", rows: sleepRows),
        MockSettingsSection(title: "Local Notifications", rows: localNotifications)
    ]
}

private func generalSettingsSection(for user: User?) -> [SettingsSection] {
    return [
        MockSettingsSection(title: "Company", rows: companyRows(for: user)),
        MockSettingsSection(title: "Personal", rows: personalRows(for: user)),
        MockSettingsSection(title: "Location", rows: locationRows),
        MockSettingsSection(title: "Calendar", rows: calendarRows),
        MockSettingsSection(title: "Sleep", rows: sleepRows),
        MockSettingsSection(title: "Tignum", rows: tignumRows)
    ]
}

private func companyRows(for user: User?) -> [SettingsRow] {
    guard let user = user else {
        return []
    }

    return [
        .label(title: "Company", value: user.company),
        .label(title: "Email", value: user.email),
        .label(title: "Telephone", value: user.telephone)
    ]
}

private func personalRows(for user: User?) -> [SettingsRow] {
    guard let user = user else {
        return []
    }

    var date = Date()
    if let dateOfBirth = user.dateOfBirth {    
        date = DateFormatter.settingsUser.date(from: dateOfBirth) ?? Date()
    }

    let selectedHeightIndex = PersonalData.height.selectedIndex(user: user)
    let selectedWeightIndex = PersonalData.weight.selectedIndex(user: user)
    let selectedHeightUnitIndex = PersonalData.height.selectedUnitIndex(user: user)
    let selectedWeightUnitIndex = PersonalData.weight.selectedUnitIndex(user: user)
    let selectedGenderIndex = Gender(rawValue: user.gender.lowercased())?.selectedIndex ?? 0

    return [
        .stringPicker(title: "Gender", pickerItems: Gender.allValuesAsStrings, selectedIndex: selectedGenderIndex),
        .datePicker(title: "Date of birth", selectedDate: date),
        .multipleStringPicker(title: "Weight", rows: user.weightPickerItems, initialSelection: [selectedWeightIndex, selectedWeightUnitIndex]),
        .multipleStringPicker(title: "Height", rows: user.heightPickerItems, initialSelection: [selectedHeightIndex, selectedHeightUnitIndex])
    ]
}

private var locationRows: [SettingsRow] {
    return [
        .control(title: "Location", isOn: true)
    ]
}

private var calendarRows: [SettingsRow] {
    return [
        .button(title: "Calendar", value: "Google Luca"),
        .control(title: "Location", isOn: true)
    ]
}

private var sleepRows: [SettingsRow] {
    return [
        .control(title: "I sleep alone", isOn: true)
    ]
}

private var localNotifications: [SettingsRow] {
    return [
        .label(title: "Show Notification", value: "Morning Inter View"),
        .label(title: "Show Notification", value: "Your 5 Weekly Choices")
    ]
}

private var tignumRows: [SettingsRow] {
    return [
        .button(title: "Tutorial", value: "Google Luca"),
        .button(title: "Initial Interview", value: "Google Luca"),
        .button(title: "Support", value: "Google Luca")
    ]
}

private var categoryNotifications: [SettingsRow] {
    return [
        .control(title: "55 Strategies", isOn: true),
        .control(title: "QOT Whats Hot", isOn: true),
        .control(title: "My To Be Visison", isOn: false),
        .control(title: "Daily Prep", isOn: true)
    ]
}

private var accountRows: [SettingsRow] {
    return [
        .textField(title: "Password", value: "password", secure: true)
    ]
}

private var aboutRows: [SettingsRow] {
    return [
        .button(title: "Terms and Conditions", value: ""),
        .button(title: "Legal Notes", value: ""),
        .button(title: "Notes and Data Protections", value: ""),
        .button(title: "Content Copyrights", value: "")
    ]
}
