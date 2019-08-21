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
        view.addFadeView(at: .bottom, height: 120, primaryColor: .carbon)
        headerView.addHeader(with: .carbonDark)
        editButton.corner(radius: editButton.frame.width/2, borderColor: UIColor.accent30)
        setContentForView()
    }

    func showLogoutAlert() {
        showAlert(type: .logout, handlerDestructive: { [weak self] in
            let key = self?.interactor?.logoutQOTKey
            self?.trackUserEvent(.SELECT, valueType: key, action: .TAP)
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
            self?.accountSettingsHeaderLabel.text = text
        })
        interactor?.contactText({[weak self] (text) in
            self?.contactHeaderLabel.text = text
        })
        interactor?.emailText({[weak self] (text) in
            self?.emailHeaderLabel.text = text
        })
        interactor?.genderText({[weak self] (text) in
            self?.genderHeaderLabel.text = text
        })
        interactor?.dateOfBirthText({[weak self] (text) in
            self?.dobHeaderLabel.text = text
        })
        interactor?.companyText({[weak self] (text) in
            self?.companyHeaderLabel.text = text
        })
        interactor?.personalDataText({[weak self] (text) in
            self?.personalDataHeaderLabel.text = text
        })
        interactor?.accountText({[weak self] (text) in
            self?.accountHeaderLabel.text = text
        })
        interactor?.changePasswordText({[weak self] (text) in
            self?.changePasswordHeaderLabel.text = text
        })
        interactor?.protectYourAccountText({[weak self] (text) in
            self?.changePasswordTitleLabel.text = text
        })
        interactor?.logoutQotText({[weak self] (text) in
            self?.logoutQotHeaderLabel.text = text
        })
        interactor?.withoutDeletingAccountText({[weak self] (text) in
            self?.logoutQotTitleLabel.text = text
        })
    }

    func setDataOnView() {
        interactor?.userProfile({[weak self] (profile) in
            self?.userEmailLabel.text = profile?.email
            self?.userCompanyLabel.text = profile?.company
            self?.userGenderLabel.text = profile?.gender
            self?.userDobLabel.text = profile?.birthday
            self?.userNameLabel.text = profile?.name
        })
    }
}
