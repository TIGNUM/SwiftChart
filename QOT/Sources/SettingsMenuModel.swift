//
//  SettingsMenuViewModel.swift
//  QOT
//
//  Created by Sam Wyndham on 13/04/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import qot_dal

final class SettingsMenuViewModel {

    private var services: Services
    private var userService: UserService {
        return services.userService
    }

    struct Tile {
        let title: String
        let subtitle: String
    }

    private lazy var tiles: [Tile] = userTiles(user: self.user)
    private let user: User
    let tileUpdates = PublishSubject<CollectionUpdate, Never>()
    private let settingTitles = [R.string.localized.sidebarSettingsMenuGeneralButton(),
                                 R.string.localized.sidebarSettingsMenuNotificationsButton(),
                                 R.string.localized.sidebarSettingsMenuSecurityButton()]
    private let timer: QOTUsageTimer

    var tileCount: Int {
        return tiles.count
    }

    var userFirstName: String {
        return user.givenName.capitalized
    }

    var userLastName: String {
        return user.familyName.capitalized
    }

    var userJobTitle: String? {
        return user.jobTitle
    }

    var userProfileImageResource: MediaResource? {
        return user.userImage
    }

    var settingsCount: Int {
        return settingTitles.count
    }

    func tile(at row: Index) -> Tile {
        return tiles[row]
    }

    func settingTitle(at row: Index) -> String {
        return settingTitles[row]
    }

    func updateProfileImage(_ image: UIImage) -> Error? {
        do {
            let url = try image.save(withName: user.localID)
            updateProfileImageURL(url)
            return nil
        } catch {
            return error
        }
    }

    init?(services: Services) {
        guard let user = services.userService.user() else { return nil }
        self.services = services
        self.timer = QOTUsageTimer.sharedInstance
        self.user = user
    }
}

// MARK: Private

private extension SettingsMenuViewModel {

    func userTiles(user: User) -> [SettingsMenuViewModel.Tile] {
        return [
            SettingsMenuViewModel.Tile(title: daysBetweenDates(startDate: user.memberSince),
                                       subtitle: R.string.localized.sidebarUserTitlesMemberSince()),
            SettingsMenuViewModel.Tile(title: usageTimeString(),
                                       subtitle: R.string.localized.sidebarUserTitlesMemberQOTUsage())
        ]
    }

    private func daysBetweenDates(startDate: Date) -> String {
        return DateComponentsFormatter.timeIntervalToString(-startDate.timeIntervalSinceNow, isShort: true)?
            .replacingOccurrences(of: ", ", with: "\n")
            .uppercased() ?? R.string.localized.qotUsageTimerDefault()
    }

    private func usageTimeString() -> String {
        if let totalUsageTime = userService.user()?.totalUsageTime {
            return timer.totalTimeString(TimeInterval(totalUsageTime))
        }
        return timer.totalTimeString(timer.totalSeconds)
    }

    private func updateProfileImageURL(_ url: URL) {
        services.userService.updateUser(user: user) { (user) in
            user.userImage?.setLocalURL(url, format: .jpg, entity: .user, entitiyLocalID: user.localID)
        }
    }
}

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

    func contentCollection(service: ContentService) -> ContentCollection? {
        switch self {
        case .copyrights: return service.contentCollection(id: 100105)
        case .terms: return service.contentCollection(id: 100102)
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

enum PersonalData {
    case weight
    case height

    var title: String {
        switch self {
        case .height: return "Height"
        case .weight: return "Weight"
        }
    }

    func selectedIndex(user: User, items: [Double]) -> Index {
        switch self {
        case .weight: return selectedIndex(value: user.weight.value, items: items)
        case .height: return selectedIndex(value: user.height.value, items: items)
        }
    }

    func selectedUnitIndex(user: User) -> Index {
        switch self {
        case .weight: return selectedUnitIndex(unit: user.weightUnit, units: ["kg", "lbs"])
        case .height: return selectedUnitIndex(unit: user.heightUnit, units: ["cm", "ft"])
        }
    }

    private func selectedIndex(value: Double?, items: [Double]) -> Index {
        var index = 0
        if let value = value {
            index = items.index(of: value) ?? 0
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

    private var settingsSections = [SettingsSection]()
    private let services: Services
    var user: QDMUser?
    private let settingsType: SettingsType.SectionType
    let updates = PublishSubject<CollectionUpdate, Never>()

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

    func updateJobTitle(title: String) {
//        services.userService.updateUserJobTitle(user: user, title: title)
    }

    func updateTelephone(telephone: String) {
//        services.userService.updateUserTelephone(user: user, telephone: telephone)
    }

    func updateDateOfBirth(dateOfBirth: String) {
//        services.userService.updateUserDateOfBirth(user: user, dateOfBirth: dateOfBirth)
    }

    func updateGender(gender: String) {
//        services.userService.updateUserGender(user: user, gender: gender.uppercased())
    }

    func updateHeight(height: Double) {
//        services.userService.updateUserHeight(user: user, height: height)
    }

    func updateNotificationSetting(key: String, value: Bool) {
        do {
            try services.settingsService.setSettingValue(SettingValue.bool(value), key: key)
        } catch let error {
//            log(error)
        }
    }

    private func items(in section: Int) -> [SettingsRow] {
        return settingsSections[section].rows
    }

    private func settingSections(user: QDMUser?, settingsType: SettingsType.SectionType) -> [SettingsSection] {
        switch settingsType {
        case .general: return generalSettingsSection(for: user, services: services)
        case .notifications: return notificationsSettingsSection(services: services)
        case .security: return securitySettingsSection
        case .profile: return generalSettingsSection(for: user, services: services)
        case .settings: return generalSettingsSection(for: user, services: services)
        }
    }

    // MARK: - Init

    init?(services: Services, settingsType: SettingsType.SectionType) {
        self.services = services
        self.settingsType = settingsType
        qot_dal.UserService.main.getUserData({ [weak self] userData in
            self?.user = userData
            self?.generateSections()
        })
    }

    func generateSections() {
        settingsSections = settingSections(user: user, settingsType: settingsType)
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
    case datePicker(title: String, selectedDate: Date, settingsType: SettingsType)
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

private var securitySettingsSection: [SettingsSection] {
    return [
        Sections(title: "Account", rows: accountRows),
        Sections(title: "About", rows: aboutRows)
    ]
}

private func notificationsSettingsSection(services: Services) -> [SettingsSection] {
    return [
        Sections(title: "", rows: categoryNotifications(services: services))
    ]
}

private func generalSettingsSection(for user: QDMUser?, services: Services) -> [SettingsSection] {
    return [
        Sections(title: "Personal Data", rows: personalRows(for: user)),
        Sections(title: "Contact", rows: companyRows(for: user))
    ]
}

private func companyRows(for user: QDMUser?) -> [SettingsRow] {
    return [
        .label(title: SettingsType.company.title, value: user?.company, settingsType: .company),
        .textField(title: SettingsType.jobTitle.title, value: user?.jobTitle ?? "", secure: false, settingsType: .jobTitle),
        .label(title: SettingsType.email.title, value: user?.email, settingsType: .email),
        .textField(title: SettingsType.phone.title, value: user?.telephone ?? "", secure: false, settingsType: .phone)
    ]
}

private func accountRows(for user: QDMUser?) -> [SettingsRow] {
    return [
        .label(title: SettingsType.password.title, value: "", settingsType: .password),
		.label(title: SettingsType.logout.title, value: "", settingsType: .logout)
	]
}

private func personalRows(for user: QDMUser?) -> [SettingsRow] {
    guard let user = user else { return [] }
    var date = Date()
    date = DateFormatter.settingsUser.date(from: user.dateOfBirth) ?? Date()
    let heightItems = user.heightPickerItems
    let weightItems = user.weightPickerItems
    let selectedHeightIndex = heightItems.valueIndex
    let selectedHeightUnitIndex = heightItems.unitIndex
    var selectedWeightIndex = weightItems.valueIndex
    let selectedWeightUnitIndex = weightItems.unitIndex
    let selectedGenderIndex = Gender(rawValue: user.gender)?.selectedIndex ?? 0

    if selectedWeightIndex == 0 && selectedWeightUnitIndex == 0 {
        selectedWeightIndex = 70
    } else if selectedWeightIndex == 0 && selectedWeightUnitIndex == 1 {
        selectedWeightIndex = 154
    }

    return [
        .textField(title: SettingsType.firstName.title, value: user.givenName, secure: false, settingsType: .firstName),
        .textField(title: SettingsType.lastName.title, value: user.familyName, secure: false, settingsType: .lastName),
        .stringPicker(title: SettingsType.gender.title,
                      pickerItems: Gender.allValues.compactMap { $0.dsiplayValue },
                      selectedIndex: selectedGenderIndex,
                      settingsType: .gender),
        .datePicker(title: SettingsType.dateOfBirth.title,
                    selectedDate: date,
                    settingsType: .dateOfBirth),
        .multipleStringPicker(title: SettingsType.height.title.components(separatedBy: ".")[0],
                              rows: user.heightPickerItems,
                              initialSelection: [selectedHeightIndex, selectedHeightUnitIndex],
                              settingsType: .height),
        .multipleStringPicker(title: SettingsType.weight.title.components(separatedBy: ".")[0],
                              rows: user.weightPickerItems,
                              initialSelection: [selectedWeightIndex, selectedWeightUnitIndex],
                              settingsType: .weight)
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
                return .control(title: systemSetting.displayName,
                                isOn: boolValue,
                                settingsType: settingType,
                                key: systemSetting.key,
                                source: nil)
            default:
                return nil
            }
        }
        return nil
    }
    return settingsRows.compactMap { $0 }
}

private var accountRows: [SettingsRow] {
    return [
        .label(title: SettingsType.password.title, value: "", settingsType: .password)
    ]
}

private var aboutRows: [SettingsRow] {
    return [
        .label(title: SettingsType.terms.title.uppercased(), value: "", settingsType: .terms),
        .label(title: SettingsType.copyrights.title.uppercased(), value: "", settingsType: .copyrights)
    ]
}
