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
    @IBOutlet private weak var bottomNavigationView: BottomNavigationBarView!
    
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
        bottomNavigationView.delegate = self
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
        accountSettingsHeaderLabel.text = interactor?.accountSettingsText
        contactHeaderLabel.text = interactor?.contactText
        emailHeaderLabel.text = interactor?.emailText
        phoneHeaderLabel.text = interactor?.phoneText
        personalDataHeaderLabel.text = interactor?.personalDataText
        heightHeaderLabel.text = interactor?.heightText
        weightHeaderLabel.text = interactor?.weightText
        accountHeaderLabel.text = interactor?.accountText
        changePasswordHeaderLabel.text = interactor?.changePasswordText
        changePasswordTitleLabel.text = interactor?.protectYourAccountText
        logoutQotHeaderLabel.text = interactor?.logoutQotText
        logoutQotTitleLabel.text = interactor?.withoutDeletingAccountText
    }
    
    func setDataOnView() {
        let user = interactor?.userProfile
        userEmailLabel.text = user?.email
        userPhoneNumberLabel.text = user?.telephone
        userHeightLabel.text = user?.userHeight
        userWeightLabel.text = user?.userWeight
        userNameLabel.text = user?.name
        userTitleLabel.text = user?.position
    }
}

extension MyQotAccountSettingsViewController: BottomNavigationBarViewProtocol {
    func willNavigateBack() {
        trackUserEvent(.CLOSE, action: .TAP)
        navigationController?.popViewController(animated: true)
    }
}
