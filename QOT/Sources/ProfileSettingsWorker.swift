//
//  ProfileSettingsWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 23/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import qot_dal


// MARK: - Form

final class ProfileSettingsWorker {

    private var settingsSections = [SettingsSection]()
    private let services: Services
    private var user: QDMUser?

    init(services: Services) {
        self.services = services
    }

    func profile(_ completion: @escaping (_ userData: QDMUser?) -> Void) {
        qot_dal.UserService.main.getUserData({ user in
            self.user = user
            self.generateSections()
            completion(self.user)
        })
    }

    func update(user: QDMUser?) {
        guard let userData = user else { return }
        qot_dal.UserService.main.updateUserData(userData) { _ in }
    }
}

extension ProfileSettingsWorker {
    
    var profile: QDMUser? {
        get {
            return user
        }
        set {
            user = newValue
        }
    }
    
    var editAccountTitle: String {
        return services.contentService.localizedString(for: ContentService.EditAccount.editAccount.predicate) ?? ""
    }
    
    func numberOfSections() -> Int {
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
    
    func generateSections() {
        settingsSections = settingSections(user: user)
    }
}

// MARK: - ContentService
private extension ProfileSettingsWorker {
    
    var personalDataTitle: String {
        return services.contentService.localizedString(for: ContentService.EditAccount.personalData.predicate) ?? ""
    }
    var contactTitle: String {
        return services.contentService.localizedString(for: ContentService.EditAccount.contact.predicate) ?? ""
    }
    var nameTitle: String {
        return services.contentService.localizedString(for: ContentService.EditAccount.name.predicate) ?? ""
    }
    var surnameTitle: String {
        return services.contentService.localizedString(for: ContentService.EditAccount.surname.predicate) ?? ""
    }
    var genderTitle: String {
        return services.contentService.localizedString(for: ContentService.EditAccount.gender.predicate) ?? ""
    }
    var dateOfBirthTitle: String {
        return services.contentService.localizedString(for: ContentService.EditAccount.dateOfBirth.predicate) ?? ""
    }
    var heightTitle: String {
        return services.contentService.localizedString(for: ContentService.EditAccount.height.predicate) ?? ""
    }
    var weightTitle: String {
        return services.contentService.localizedString(for: ContentService.EditAccount.weight.predicate) ?? ""
    }
    var companyTitle: String {
        return services.contentService.localizedString(for: ContentService.EditAccount.company.predicate) ?? ""
    }
    var titleTitle: String {
        return services.contentService.localizedString(for: ContentService.EditAccount.title.predicate) ?? ""
    }
    
    var emailTitle: String {
        return services.contentService.localizedString(for: ContentService.EditAccount.email.predicate) ?? ""
    }
    
    var phoneTitle: String {
        return services.contentService.localizedString(for: ContentService.EditAccount.phone.predicate) ?? ""
    }
}

private extension ProfileSettingsWorker {
    
    private func generalSettingsSection(for user: QDMUser?, services: Services) -> [SettingsSection] {
        return [
            Sections(title: personalDataTitle, rows: personalRows(for: user)),
            Sections(title: contactTitle, rows: companyRows(for: user))
        ]
    }
    
    private func items(in section: Int) -> [SettingsRow] {
        return settingsSections[section].rows
    }
    
    private func settingSections(user: QDMUser?) -> [SettingsSection] {
        return generalSettingsSection(for: user, services: services)
    }
    
    private func companyRows(for user: QDMUser?) -> [SettingsRow] {
        return [
            .label(title: companyTitle, value: user?.company, settingsType: .company),
            .textField(title: titleTitle, value: user?.jobTitle ?? "", secure: false, settingsType: .jobTitle),
            .label(title: emailTitle, value: user?.email, settingsType: .email),
            .textField(title: phoneTitle, value: user?.telephone ?? "", secure: false, settingsType: .phone)
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
            .textField(title: nameTitle, value: user.givenName, secure: false, settingsType: .firstName),
            .textField(title: surnameTitle, value: user.familyName, secure: false, settingsType: .lastName),
            .stringPicker(title: genderTitle,
                          pickerItems: Gender.allValues.compactMap { $0.dsiplayValue },
                          selectedIndex: selectedGenderIndex,
                          settingsType: .gender),
            .datePicker(title: dateOfBirthTitle,
                        selectedDate: date,
                        settingsType: .dateOfBirth),
            .multipleStringPicker(title: heightTitle,
                                  rows: user.heightPickerItems,
                                  initialSelection: [selectedHeightIndex, selectedHeightUnitIndex],
                                  settingsType: .height),
            .multipleStringPicker(title: weightTitle,
                                  rows: user.weightPickerItems,
                                  initialSelection: [selectedWeightIndex, selectedWeightUnitIndex],
                                  settingsType: .weight),
        ]
    }

}
