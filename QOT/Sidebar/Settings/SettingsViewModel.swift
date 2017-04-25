//
//  SettingsViewModel.swift
//  QOT
//
//  Created by Sam Wyndham on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class SettingsViewModel {

    enum SettingsType {
        case general
        case notifications
        case security
    }

    // MARK: - Properties

    private let settingSections: [SettingsSection]
    let settingsType: SettingsType
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var sectionCount: Int {
        return settingSections.count
    }

    func numberOfItemsInSection(in section: Int) -> Int {
        return items(in: section).count
    }

    func row(at indexPath: IndexPath) -> SettingsRow {
        return items(in: indexPath.section)[indexPath.row]
    }

    private func items(in section: Int) -> [SettingsRow] {
        return settingSections[section].rows
    }

    // MARK: - Init
    
    init(settingsType: SettingsType) {
        self.settingSections = mockSettingSections(settingsType: settingsType)
        self.settingsType = settingsType
    }
}

protocol SettingsSection {
    var title: String { get }
    var rows: [SettingsRow] { get }
}

enum SettingsRow {
    case label(title: String, value: String)
    case stringPicker(title: String, pickerItems: [String], selectedIndex: Index)
    case datePicker(title: String, selectedDate: Date)
    case control(title: String, enabled: Bool)
    case button(title: String, value: String)
    case textField(title: String, value: String, secure: Bool)
    case navigation(title: String, value: String)
}

struct MockSettingsSection: SettingsSection {
    let title: String
    let rows: [SettingsRow]
}

private func mockSettingSections(settingsType: SettingsViewModel.SettingsType) -> [SettingsSection] {
    switch settingsType {
    case .general: return mockGeneralSettingsSection
    case .notifications: return mockNotificationsSettingsSection
    case .security: return mockSecuritySettingsSection
    }
}

private var mockSecuritySettingsSection: [SettingsSection] {
    return [
        MockSettingsSection(title: "Account", rows: accountRows),
        MockSettingsSection(title: "About", rows: aboutRows)
    ]
}

private var mockNotificationsSettingsSection: [SettingsSection] {
    return [
        MockSettingsSection(title: "Categories", rows: categoryNotifications),
        MockSettingsSection(title: "Reminder", rows: sleepRows)
    ]
}

private var mockGeneralSettingsSection: [SettingsSection] {
    return [
        MockSettingsSection(title: "Company", rows: companyRows),
        MockSettingsSection(title: "Personal", rows: personalRows),
        MockSettingsSection(title: "Location", rows: locationRows),
        MockSettingsSection(title: "Calendaar", rows: calendarRows),
        MockSettingsSection(title: "Sleep", rows: sleepRows),
        MockSettingsSection(title: "Tignum", rows: tignumRows)
    ]
}

private var companyRows: [SettingsRow] {
    return [
        .label(title: "Company", value: "Tignum"),
        .label(title: "Email", value: "tignum@tignum.com"),
        .label(title: "Telephone", value: "555 42 23")
    ]
}

private var personalRows: [SettingsRow] {
    return [
        .stringPicker(title: "Gender", pickerItems: ["Female", "Male"], selectedIndex: 0),
        .datePicker(title: "Date of birth", selectedDate: Date()),
        .stringPicker(title: "Weight", pickerItems: ["Female", "Male"], selectedIndex: 0),
        .stringPicker(title: "Height", pickerItems: ["Female", "Male"], selectedIndex: 0)
    ]
}

private var locationRows: [SettingsRow] {
    return [
        .control(title: "Location", enabled: true)
    ]
}

private var calendarRows: [SettingsRow] {
    return [
        .button(title: "Calendar", value: "Google Luca"),
        .control(title: "Location", enabled: true)
    ]
}

private var sleepRows: [SettingsRow] {
    return [
        .control(title: "I sleep alone", enabled: true)
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
        .control(title: "55 Strategies", enabled: true),
        .control(title: "QOT Whats Hot", enabled: true),
        .control(title: "My To Be Visison", enabled: false),
        .control(title: "Daily Prep", enabled: true)
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
