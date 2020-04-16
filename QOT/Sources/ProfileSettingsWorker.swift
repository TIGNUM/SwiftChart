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
    private let contentService: ContentService
    private var user: QDMUser?
    private let dispatchGroup = DispatchGroup()

    private var personalTxt = ""
    private var contactTxt = ""
    private var nameTxt = ""
    private var surnameTxt = ""
    private var companyTxt = ""
    private var emailTxt = ""

    lazy var confirmationAlertTitle: String = {
        return AppTextService.get(.my_qot_my_profile_account_settings_alert_continue_without_saving_title)
    }()

    lazy var confirmationAlertMessage: String = {
        return AppTextService.get(.my_qot_my_profile_account_settings_alert_continue_without_saving_body)
    }()

    lazy var confirmationAlertDone: String = {
        return AppTextService.get(.my_qot_my_profile_account_settings_alert_continue_without_saving_button_continue)
    }()

    lazy var confirmationAlertCancel: String = {
        return AppTextService.get(.generic_view_button_cancel)
    }()

    init(contentService: ContentService) {
        self.contentService = contentService
    }

    func getData(_ completion: @escaping (_ userData: QDMUser?) -> Void) {
        contactTitle()
        nameTitle()
        surnameTitle()
        companyTitle()
        emailTitle()
        getProfile()

        dispatchGroup.notify(queue: .main) {
            completion(self.user)
        }
    }

    private func getProfile() {
        dispatchGroup.enter()
        UserService.main.getUserData({[weak self] user in
            self?.user = user
            self?.generateSections()
            self?.dispatchGroup.leave()
        })
    }

    func update(user: QDMUser?, _ completion: @escaping () -> Void) {
        guard let userData = user else { return }
        UserService.main.updateUserData(userData) { _ in
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

    var editAccountTitle: String {
        return AppTextService.get(.my_qot_my_profile_account_settings_edit_title_edit_account)
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
    func contactTitle() {
        contactTxt = AppTextService.get(.my_qot_my_profile_account_settings_edit_title_contact)
    }

    func nameTitle() {
        nameTxt = AppTextService.get(.my_qot_my_profile_account_settings_edit_label_name)
    }

    func surnameTitle() {
        surnameTxt = AppTextService.get(.my_qot_my_profile_account_settings_edit_title_surname)
    }

    func companyTitle() {
        companyTxt = AppTextService.get(.my_qot_my_profile_account_settings_edit_label_company)
    }

    func emailTitle() {
        emailTxt = AppTextService.get(.my_qot_my_profile_account_settings_edit_label_email)
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
        return [.textField(title: nameTxt, value: user.givenName, secure: false, settingsType: .firstName),
                .textField(title: surnameTxt, value: user.familyName, secure: false, settingsType: .lastName)]
    }
}
