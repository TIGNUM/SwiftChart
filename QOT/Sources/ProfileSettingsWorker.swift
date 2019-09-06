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
    private var dateOfBirthTxt = ""
    private var companyTxt = ""
    private var emailTxt = ""

    lazy var confirmationAlertTitle: String = {
        return ScreenTitleService.main.localizedString(for: .ProfileConfirmationheader)
    }()

    lazy var confirmationAlertMessage: String = {
        return ScreenTitleService.main.localizedString(for: .ProfileConfirmationdescription)
    }()

    lazy var confirmationAlertDone: String = {
        return ScreenTitleService.main.localizedString(for: .MySprintDetailsButtonContinue)
    }()

    lazy var confirmationAlertCancel: String = {
        return ScreenTitleService.main.localizedString(for: .ButtonTitleCancel)
    }()

    init(contentService: qot_dal.ContentService) {
        self.contentService = contentService
    }

    func getData(_ completion: @escaping (_ userData: QDMUser?) -> Void) {
        personalDataTitle()
        contactTitle()
        nameTitle()
        surnameTitle()
        dateOfBirthTitle()
        companyTitle()
        emailTitle()
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

    func update(user: QDMUser?, _ completion: @escaping () -> Void) {
        guard let userData = user else { return }
        qot_dal.UserService.main.updateUserData(userData) { _ in
            completion()
        }
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

    func dateOfBirthTitle() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.EditAccount.yearOfBirth.predicate) {[weak self] (contentItem) in
            self?.dateOfBirthTxt = contentItem?.valueText ?? ""
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

    func emailTitle() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.EditAccount.email.predicate) {[weak self] (contentItem) in
            self?.emailTxt = contentItem?.valueText ?? ""
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
            .label(title: emailTxt, value: user?.email, settingsType: .email)
        ]
    }

    private func personalRows(for user: QDMUser?) -> [SettingsRow] {
        guard let user = user else { return [] }
        let date = DateFormatter.yyyyMMdd.date(from: user.dateOfBirth) ?? Date()
        return [
            .textField(title: nameTxt, value: user.givenName, secure: false, settingsType: .firstName),
            .textField(title: surnameTxt, value: user.familyName, secure: false, settingsType: .lastName),
            .datePicker(title: dateOfBirthTxt,
                        yearOfBirth: String(date.year()),
                        settingsType: .dateOfBirth)
        ]
    }
}
