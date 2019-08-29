//
//  MyQotAccountSettingsViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 08.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAccountSettingsViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var accountSettingsHeaderLabel: UILabel!
    @IBOutlet private weak var contactHeaderLabel: UILabel!
    @IBOutlet private weak var emailHeaderLabel: UILabel!
    @IBOutlet private weak var companyHeaderLabel: UILabel!
    @IBOutlet private weak var personalDataHeaderLabel: UILabel!
    @IBOutlet private weak var genderHeaderLabel: UILabel!
    @IBOutlet private weak var dobHeaderLabel: UILabel!
    @IBOutlet private weak var accountHeaderLabel: UILabel!
    @IBOutlet private weak var changePasswordHeaderLabel: UILabel!
    @IBOutlet private weak var changePasswordTitleLabel: UILabel!
    @IBOutlet private weak var logoutQotHeaderLabel: UILabel!
    @IBOutlet private weak var logoutQotTitleLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userCompanyLabel: UILabel!
    @IBOutlet private weak var userEmailLabel: UILabel!
    @IBOutlet private weak var userGenderLabel: UILabel!
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
        showAlert(type: .logout, handlerDestructive: { [weak self] in
            let key = self?.interactor?.logoutQOTKey
            self?.trackUserEvent(.SELECT, valueType: key, action: .TAP)
            self?.dismiss(animated: false, completion: nil)
            self?.interactor?.logout()
        })
    }

    func showResetPasswordAlert() {
        showAlert(type: .changePassword, handlerDestructive: { [weak self] in
            let key = self?.interactor?.changePasswordKey
            self?.trackUserEvent(.SELECT, valueType: key, action: .TAP)
            self?.interactor?.resetPassword()
        })
    }
}

private extension MyQotAccountSettingsViewController {
    func setContentForView() {
        interactor?.accountSettingsText({[weak self] (text) in
            ThemeText.myQOTSectionHeader.apply(text, to: self?.accountSettingsHeaderLabel)
        })
        interactor?.contactText({[weak self] (text) in
            ThemeText.accountHeader.apply(text, to: self?.contactHeaderLabel)
        })
        interactor?.emailText({[weak self] (text) in
            ThemeText.accountHeader.apply(text, to: self?.emailHeaderLabel)
        })
        interactor?.genderText({[weak self] (text) in
            ThemeText.accountHeader.apply(text, to: self?.genderHeaderLabel)
        })
        interactor?.dateOfBirthText({[weak self] (text) in
            ThemeText.accountHeader.apply(text, to: self?.dobHeaderLabel)
        })
        interactor?.companyText({[weak self] (text) in
            ThemeText.accountHeader.apply(text, to: self?.companyHeaderLabel)
        })
        interactor?.personalDataText({[weak self] (text) in
            ThemeText.accountHeader.apply(text, to: self?.personalDataHeaderLabel)
        })
        interactor?.accountText({[weak self] (text) in
            ThemeText.accountHeader.apply(text, to: self?.accountHeaderLabel)
        })
        interactor?.changePasswordText({[weak self] (text) in
            ThemeText.accountHeader.apply(text, to: self?.changePasswordHeaderLabel)
        })
        interactor?.protectYourAccountText({[weak self] (text) in
            ThemeText.accountHeader.apply(text, to: self?.changePasswordTitleLabel)
        })
        interactor?.logoutQotText({[weak self] (text) in
            ThemeText.accountHeader.apply(text, to: self?.logoutQotHeaderLabel)
        })
        interactor?.withoutDeletingAccountText({[weak self] (text) in
            ThemeText.accountHeader.apply(text, to: self?.logoutQotTitleLabel)
        })
    }

    func setDataOnView() {
        interactor?.userProfile({[weak self] (profile) in
            ThemeText.accountDetail.apply(profile?.email, to: self?.userEmailLabel)
            ThemeText.accountDetail.apply(profile?.company, to: self?.userCompanyLabel)
            ThemeText.accountDetail.apply(profile?.gender, to: self?.userGenderLabel)
            ThemeText.accountDetail.apply(profile?.birthday, to: self?.userDobLabel)
            ThemeText.accountDetail.apply(profile?.name, to: self?.userNameLabel)
        })
    }
}
