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
    @IBOutlet private weak var phoneHeaderLabel: UILabel!
    @IBOutlet private weak var personalDataHeaderLabel: UILabel!
    @IBOutlet private weak var heightHeaderLabel: UILabel!
    @IBOutlet private weak var weightHeaderLabel: UILabel!
    @IBOutlet private weak var accountHeaderLabel: UILabel!
    @IBOutlet private weak var changePasswordHeaderLabel: UILabel!
    @IBOutlet private weak var changePasswordTitleLabel: UILabel!
    @IBOutlet private weak var logoutQotHeaderLabel: UILabel!
    @IBOutlet private weak var logoutQotTitleLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userTitleLabel: UILabel!
    @IBOutlet private weak var userPhoneNumberLabel: UILabel!
    @IBOutlet private weak var userEmailLabel: UILabel!
    @IBOutlet private weak var userHeightLabel: UILabel!
    @IBOutlet private weak var userWeightLabel: UILabel!
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
        interactor?.phoneText({[weak self] (text) in
            self?.phoneHeaderLabel.text = text
        })
        interactor?.personalDataText({[weak self] (text) in
            self?.personalDataHeaderLabel.text = text
        })
        interactor?.heightText({[weak self] (text) in
            self?.heightHeaderLabel.text = text
        })
        interactor?.weightText({[weak self] (text) in
            self?.weightHeaderLabel.text = text
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
            self?.userPhoneNumberLabel.text = profile?.telephone
            self?.userHeightLabel.text = profile?.userHeight
            self?.userWeightLabel.text = profile?.userWeight
            self?.userNameLabel.text = profile?.name
            self?.userTitleLabel.text = profile?.position
        })
    }
}
