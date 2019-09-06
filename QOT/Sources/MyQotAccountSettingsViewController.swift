//
//  MyQotAccountSettingsViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 08.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQotAccountSettingsViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties

    @IBOutlet private weak var accountSettingsHeaderLabel: UILabel!
    @IBOutlet private weak var contactHeaderLabel: UILabel!
    @IBOutlet private weak var emailHeaderLabel: UILabel!
    @IBOutlet private weak var companyHeaderLabel: UILabel!
    @IBOutlet private weak var personalDataHeaderLabel: UILabel!
    @IBOutlet private weak var genderHeaderLabel: UILabel!
    @IBOutlet private weak var dobHeaderLabel: UILabel!
    @IBOutlet private weak var logoutQotHeaderLabel: UILabel!
    @IBOutlet private weak var logoutQotTitleLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userCompanyLabel: UILabel!
    @IBOutlet private weak var userEmailLabel: UILabel!
    @IBOutlet private weak var userDobLabel: UILabel!
    @IBOutlet private weak var headerTitle: UILabel!
    @IBOutlet private weak var headerLine: UIView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var editButton: UIButton!

    var interactor: MyQotAccountSettingsInteractor?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDataOnView()
        UIApplication.shared.statusBarView?.backgroundColor = .carbonDark
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UIApplication.shared.statusBarView?.backgroundColor = .carbon
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editProfileVC  = segue.destination as? ProfileSettingsViewController {
            ProfileSettingsConfigurator.configure(viewController: editProfileVC)
        }
    }

    // MARK: - Actions

    @IBAction func logout(_ sender: Any) {
        interactor?.showLogoutAlert()
    }

    @IBAction func changePassword(_ sender: Any) {
        interactor?.showResetPasswordAlert()
    }

    @IBAction func presentEditAccountSettings(_ sender: Any) {
        trackUserEvent(.EDIT, action: .TAP)
        interactor?.presentEditAccountSettings()
    }
}

// MARK: - MyQotViewControllerInterface

extension MyQotAccountSettingsViewController: MyQotAccountSettingsViewControllerInterface {
    func setupView() {
        ThemeView.level3.apply(view)
        ThemeText.sectionHeader.apply(headerTitle.text, to: headerTitle)
        ThemeView.headerLine.apply(headerLine)

        ThemeView.level3.apply(headerView)
        headerView.addHeader(with: .level3)
        editButton.corner(radius: editButton.frame.width/2, borderColor: UIColor.accent30)
        setContentForView()
    }

    func showLogoutAlert() {
        let cancel = QOTAlertAction(title: ScreenTitleService.main.localizedString(for: .ButtonTitleCancel))
        let logout = QOTAlertAction(title: R.string.localized.sidebarTitleLogout()) { [weak self] (_) in
            let key = self?.interactor?.logoutQOTKey
            self?.trackUserEvent(.SELECT, valueType: key, action: .TAP)
            self?.dismiss(animated: false, completion: nil)
            self?.interactor?.logout()
        }
        QOTAlert.show(title: nil, message: R.string.localized.alertMessageLogout(), bottomItems: [cancel, logout])
    }

    func showResetPasswordAlert() {
        let cancel = QOTAlertAction(title: ScreenTitleService.main.localizedString(for: .ButtonTitleCancel))
        let change = QOTAlertAction(title: R.string.localized.settingsChangePasswordButton()) { [weak self] (_) in
            let key = self?.interactor?.changePasswordKey
            self?.trackUserEvent(.SELECT, valueType: key, action: .TAP)
            self?.interactor?.resetPassword()
        }
        QOTAlert.show(title: nil, message: R.string.localized.settingsChangePasswordTitle(), bottomItems: [cancel, change])
    }
}

private extension MyQotAccountSettingsViewController {
    func setContentForView() {
        ThemeText.myQOTSectionHeader.apply(interactor?.accountSettingsText, to: accountSettingsHeaderLabel)
        ThemeText.accountHeader.apply(interactor?.contactText, to: contactHeaderLabel)
        ThemeText.accountHeader.apply(interactor?.emailText, to: emailHeaderLabel)
        dobHeaderLabel.text = interactor?.dateOfBirthText
        ThemeText.accountHeader.apply(interactor?.companyText, to: companyHeaderLabel)
        ThemeText.accountHeader.apply(interactor?.personalDataText, to: personalDataHeaderLabel)
        ThemeText.accountHeaderTitle.apply(interactor?.logoutQotText, to: logoutQotHeaderLabel)
        ThemeText.accountDetail.apply(interactor?.withoutDeletingAccountText, to: logoutQotTitleLabel)
    }

    func setDataOnView() {
        interactor?.userProfile({[weak self] (profile) in
            ThemeText.accountDetail.apply(profile?.email, to: self?.userEmailLabel)
            ThemeText.accountDetail.apply(profile?.company, to: self?.userCompanyLabel)
            ThemeText.accountDetail.apply(profile?.yearOfBirth, to: self?.userDobLabel)
            ThemeText.accountDetail.apply(profile?.name, to: self?.userNameLabel)
        })
    }
}
