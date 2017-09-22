//
//  SettingsViewModel.swift
//  QOT
//
//  Created by Sam Wyndham on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

enum SettingsType: Int {
    case company = 0
    case email
    case phone
    case gender
    case dateOfBirth
    case weight
    case height
    case location
    case calendar    
    case tutorial
    case interview
    case support
    case strategies
    case dailyPrep
    case weeklyChoices
    case password
    case confirm
    case terms
    case legalNotes
    case dataProtection
    case copyrights
    case security

    var title: String {
        switch self {
        case .company: return R.string.localized.settingsGeneralCompanyTitle()
        case .email: return R.string.localized.settingsGeneralEmailTitle()
        case .phone: return R.string.localized.settingsGeneralTelephoneTitle()
        case .gender: return R.string.localized.settingsGeneralGenderTitle()
        case .dateOfBirth: return R.string.localized.settingsGeneralDateOfBirthTitle()
        case .weight: return R.string.localized.settingsGeneralWeightTitle()
        case .height: return R.string.localized.settingsGeneralHeightTitle()
        case .location: return R.string.localized.settingsGeneralLocationTitle()
        case .calendar: return R.string.localized.settingsGeneralCalendarTitle()
        case .tutorial: return R.string.localized.settingsGeneralTutorialTitle()
        case .interview: return R.string.localized.settingsGeneralInterviewTitle()
        case .support: return R.string.localized.settingsGeneralSupportTitle()
        case .strategies: return R.string.localized.settingsNotificationsStrategiesTitle()
        case .dailyPrep: return R.string.localized.settingsNotificationsDailyPrepTitle()
        case .weeklyChoices: return R.string.localized.settingsNotificationsWeeklyChoicesTitle()
        case .password: return R.string.localized.settingsSecurityPasswordTitle()
        case .confirm: return R.string.localized.settingsSecurityConfirmTitle()
        case .terms: return R.string.localized.settingsSecurityTermsTitle()
        case .legalNotes: return R.string.localized.settingsSecurityLegalNotesTitle()
        case .dataProtection: return R.string.localized.settingsSecurityDataProtectionTitle()
        case .copyrights: return R.string.localized.settingsSecurityCopyrightsTitle()
        case .security: return R.string.localized.settingsSecurityDataSecurityTitle()
        }
    }

    func contentCollection(service: ContentService) -> ContentCollection? {
        switch self {
        case .copyrights: return service.contentCollection(id: 100105)
        case .terms: return service.contentCollection(id: 100102)
        case .legalNotes: return service.contentCollection(id: 100103)
        case .dataProtection: return service.contentCollection(id: 100104)
        case .security: return service.contentCollection(id: 100163)
        default: return nil
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

        var title: String {
            switch self {
            case .general: return R.string.localized.settingsTitleGeneral()
            case .notifications: return R.string.localized.settingsTitleNotifications()
            case .security: return R.string.localized.settingsTitleSecurity()
            }
        }
    }
}

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

    // MARK: - Properties

    fileprivate var settingsSections = [SettingsSection]()
    fileprivate let services: Services
    fileprivate let user: User
    fileprivate let settingsType: SettingsType.SectionType
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
        services.userService.updateUserGender(user: user, gender: gender.uppercased())
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

    func updateNotificationSetting(key: String, value: Bool) {
        do {
            try services.settingsService.setSettingValue(SettingValue.bool(value), key: key)
        } catch let error {
            print(error)
        }
    }

    private func items(in section: Int) -> [SettingsRow] {
        return settingsSections[section].rows
    }

    private func settingSections(user: User?, settingsType: SettingsType.SectionType) -> [SettingsSection] {
        switch settingsType {
        case .general: return generalSettingsSection(for: user)
        case .notifications: return notificationsSettingsSection(services: services)
        case .security: return securitySettingsSection
        }
    }

    // MARK: - Init
    
    init?(services: Services, settingsType: SettingsType.SectionType) {
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

    case label(title: String, value: String?, settingsType: SettingsType)
    case stringPicker(title: String, pickerItems: [String], selectedIndex: Index, settingsType: SettingsType)
    case multipleStringPicker(title: String, rows: [[String]], initialSelection: [Index], settingsType: SettingsType)
    case datePicker(title: String, selectedDate: Date, settingsType: SettingsType)
    case control(title: String, isOn: Bool, settingsType: SettingsType, key: String?)
    case button(title: String, value: String, settingsType: SettingsType)
    case textField(title: String, value: String, secure: Bool, settingsType: SettingsType)

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

private func notificationsSettingsSection(services: Services) -> [SettingsSection] {
    return [
        MockSettingsSection(title: "Categories", rows: categoryNotifications(services: services))        
    ]
}

private func generalSettingsSection(for user: User?) -> [SettingsSection] {
    return [
        MockSettingsSection(title: "Company", rows: companyRows(for: user)),
        MockSettingsSection(title: "Personal", rows: personalRows(for: user)),
        MockSettingsSection(title: "Location", rows: locationRows),
        MockSettingsSection(title: "Calendar", rows: calendarRows)
//        MockSettingsSection(title: "QOT", rows: tignumRows)
    ]
}

private func companyRows(for user: User?) -> [SettingsRow] {
    guard let user = user else {
        return []
    }

    return [
        .label(title: SettingsType.company.title, value: user.company, settingsType: .company),
        .label(title: SettingsType.email.title, value: user.email, settingsType: .email),
        .label(title: SettingsType.phone.title, value: user.telephone, settingsType: .phone)
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
        .stringPicker(title: SettingsType.gender.title, pickerItems: Gender.allValuesAsStrings, selectedIndex: selectedGenderIndex, settingsType: .gender),
        .datePicker(title: SettingsType.dateOfBirth.title, selectedDate: date, settingsType: .dateOfBirth),
        .multipleStringPicker(title: SettingsType.weight.title, rows: user.weightPickerItems, initialSelection: [selectedWeightIndex, selectedWeightUnitIndex], settingsType: .weight),
        .multipleStringPicker(title: SettingsType.height.title, rows: user.heightPickerItems, initialSelection: [selectedHeightIndex, selectedHeightUnitIndex], settingsType: .height)
    ]
}

private var locationRows: [SettingsRow] {
    let authorizationStatus = LocationManager.authorizationStatus == .authorizedAlways || LocationManager.authorizationStatus == .authorizedWhenInUse
    let canShareLocation = authorizationStatus == true && UserDefault.locationService.boolValue == true

    return [
        .control(title: SettingsType.location.title, isOn: canShareLocation, settingsType: .location, key: UserDefault.locationService.rawValue)
    ]
}

private var calendarRows: [SettingsRow] {
    return [
        .label(title: SettingsType.calendar.title, value: "", settingsType: .calendar)
    ]
}

private var tignumRows: [SettingsRow] {
    return [
        .label(title: SettingsType.tutorial.title, value: "", settingsType: .tutorial),
        .label(title: SettingsType.interview.title, value: "", settingsType: .interview),
        .label(title: SettingsType.support.title, value: "", settingsType: .support)
    ]
}

private func categoryNotifications(services: Services) -> [SettingsRow] {
    let service = services.settingsService
    let notificationSettings = service.notificationSettings()
    let settingsRows = notificationSettings.map { (systemSetting) -> SettingsRow? in
        let key = systemSetting.key
        if let settingType = SettingsType.notificationType(key: key), let value = service.settingValue(key: key) {
            switch value {
            case .bool(let boolValue):
                return .control(title: systemSetting.displayName, isOn: boolValue, settingsType: settingType, key: systemSetting.key)
            default:
                return nil
            }
        }
        return nil
    }
    return settingsRows.flatMap { $0 }
}

private var accountRows: [SettingsRow] {
    return [
        .label(title: SettingsType.password.title, value: "", settingsType: .password)
    ]
}

private var aboutRows: [SettingsRow] {
    return [
        .label(title: SettingsType.terms.title, value: "", settingsType: .terms),
        .label(title: SettingsType.legalNotes.title, value: "", settingsType: .legalNotes),
        .label(title: SettingsType.dataProtection.title, value: "", settingsType: .dataProtection),
        .label(title: SettingsType.copyrights.title, value: "", settingsType: .copyrights),
        .label(title: SettingsType.security.title, value: "", settingsType: .security)
    ]
}
