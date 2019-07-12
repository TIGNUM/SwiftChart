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
    private let contentService: qot_dal.ContentService
    private var user: QDMUser?
    private let dispatchGroup = DispatchGroup()

    private var personalTxt = ""
    private var contactTxt = ""
    private var nameTxt = ""
    private var surnameTxt = ""
    private var genderTxt = ""
    private var dateOfBirthTxt = ""
    private var heightTxt = ""
    private var weightTxt = ""
    private var companyTxt = ""
    private var titleTxt = ""
    private var emailTxt = ""
    private var phoneTxt = ""

    init(contentService: qot_dal.ContentService) {
        self.contentService = contentService
    }

    func getData(_ completion: @escaping (_ userData: QDMUser?) -> Void) {
        personalDataTitle()
        contactTitle()
        nameTitle()
        surnameTitle()
        genderTitle()
        dateOfBirthTitle()
        heightTitle()
        weightTitle()
        companyTitle()
        titleTitle()
        emailTitle()
        phoneTitle()
        getProfile()

        dispatchGroup.notify(queue: .main) {
            completion(self.user)
        }
    }

    private func getProfile() {
        dispatchGroup.enter()
        qot_dal.UserService.main.getUserData({[weak self] user in
            self?.user = user
            self?.generateSections()
            self?.dispatchGroup.leave()
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

    func editAccountTitle(_ completion: @escaping (_ userData: String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.EditAccount.editAccount.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
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

    func personalDataTitle() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.EditAccount.personalData.predicate) {[weak self] (contentItem) in
            self?.personalTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func contactTitle() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.EditAccount.contact.predicate) {[weak self] (contentItem) in
            self?.contactTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func nameTitle() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.EditAccount.name.predicate) {[weak self] (contentItem) in
            self?.nameTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func surnameTitle() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.EditAccount.surname.predicate) {[weak self] (contentItem) in
            self?.surnameTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func genderTitle() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.EditAccount.gender.predicate) {[weak self] (contentItem) in
            self?.genderTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func dateOfBirthTitle() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.EditAccount.dateOfBirth.predicate) {[weak self] (contentItem) in
            self?.dateOfBirthTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func heightTitle() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.EditAccount.height.predicate) {[weak self] (contentItem) in
            self?.heightTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func weightTitle() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.EditAccount.weight.predicate) {[weak self] (contentItem) in
            self?.weightTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func companyTitle() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.EditAccount.company.predicate) {[weak self] (contentItem) in
            self?.companyTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func titleTitle() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.EditAccount.title.predicate) {[weak self] (contentItem) in
            self?.titleTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func emailTitle() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.EditAccount.email.predicate) {[weak self] (contentItem) in
            self?.emailTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func phoneTitle() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.EditAccount.phone.predicate) {[weak self] (contentItem) in
            self?.phoneTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }
}

private extension ProfileSettingsWorker {

    private func generalSettingsSection(for user: QDMUser?) -> [SettingsSection] {
        return [
            Sections(title: personalTxt, rows: personalRows(for: user)),
            Sections(title: contactTxt, rows: companyRows(for: user))
        ]
    }

    private func items(in section: Int) -> [SettingsRow] {
        return settingsSections[section].rows
    }

    private func settingSections(user: QDMUser?) -> [SettingsSection] {
        return generalSettingsSection(for: user)
    }

    private func companyRows(for user: QDMUser?) -> [SettingsRow] {
        return [
            .label(title: companyTxt, value: user?.company, settingsType: .company),
            .textField(title: titleTxt, value: user?.jobTitle ?? "", secure: false, settingsType: .jobTitle),
            .label(title: emailTxt, value: user?.email, settingsType: .email),
            .textField(title: phoneTxt, value: user?.telephone ?? "", secure: false, settingsType: .phone)
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
            .textField(title: nameTxt, value: user.givenName, secure: false, settingsType: .firstName),
            .textField(title: surnameTxt, value: user.familyName, secure: false, settingsType: .lastName),
            .stringPicker(title: genderTxt,
                          pickerItems: Gender.allValues.compactMap { $0.dsiplayValue },
                          selectedIndex: selectedGenderIndex,
                          settingsType: .gender),
            .datePicker(title: dateOfBirthTxt,
                        selectedDate: date,
                        settingsType: .dateOfBirth),
            .multipleStringPicker(title: heightTxt,
                                  rows: user.heightPickerItems,
                                  initialSelection: [selectedHeightIndex, selectedHeightUnitIndex],
                                  settingsType: .height),
            .multipleStringPicker(title: weightTxt,
                                  rows: user.weightPickerItems,
                                  initialSelection: [selectedWeightIndex, selectedWeightUnitIndex],
                                  settingsType: .weight)
        ]
    }

}
