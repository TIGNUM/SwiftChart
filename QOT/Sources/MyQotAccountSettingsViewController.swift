//
//  MyQotAccountSettingsViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 08.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQotAccountSettingsViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties

    @IBOutlet private weak var accountSettingsHeaderLabel: UILabel!
    @IBOutlet private weak var contactHeaderLabel: UILabel!
    @IBOutlet private weak var emailHeaderLabel: UILabel!
    @IBOutlet private weak var companyHeaderLabel: UILabel!
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
        ThemeView.level2.apply(UIApplication.shared.statusBarView ?? UIView())
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
        let cancel = QOTAlertAction(title: AppTextService.get(AppTextKey.generic_view_cancel_button_title))
        let logout = QOTAlertAction(title: AppTextService.get(AppTextKey.my_qot_account_settings_alert_logout_button)) { [weak self] (_) in
            let key = self?.interactor?.logoutQOTKey
            self?.trackUserEvent(.SELECT, valueType: key, action: .TAP)
            self?.dismiss(animated: false, completion: nil)
            self?.interactor?.logout()
        }
        QOTAlert.show(title: nil, message: AppTextService.get(AppTextKey.my_qot_account_settings_alert_logout_body), bottomItems: [cancel, logout])
    }
}

private extension MyQotAccountSettingsViewController {
    func setContentForView() {
        ThemeText.myQOTSectionHeader.apply(interactor?.accountSettingsText, to: accountSettingsHeaderLabel)
        ThemeText.accountHeader.apply(interactor?.contactText, to: contactHeaderLabel)
        ThemeText.accountHeader.apply(interactor?.emailText, to: emailHeaderLabel)
        ThemeText.accountHeader.apply(interactor?.dateOfBirthText, to: dobHeaderLabel)
        ThemeText.accountHeader.apply(interactor?.companyText, to: companyHeaderLabel)
        ThemeText.accountHeaderTitle.apply(interactor?.logoutQotText, to: logoutQotHeaderLabel)
        ThemeText.accountDetail.apply(interactor?.withoutDeletingAccountText, to: logoutQotTitleLabel)
    }

    func setDataOnView() {
        interactor?.userProfile({[weak self] (profile) in
            ThemeText.accountDetailEmail.apply(profile?.email, to: self?.userEmailLabel)
            ThemeText.accountDetailEmail.apply(profile?.company, to: self?.userCompanyLabel)
            ThemeText.accountDetailAge.apply(profile?.yearOfBirth, to: self?.userDobLabel)
            ThemeText.accountUserName.apply(profile?.name, to: self?.userNameLabel)
        })
    }
}
