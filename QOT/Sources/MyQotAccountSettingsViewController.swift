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
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var emailHeaderLabel: UILabel!
    @IBOutlet private weak var companyHeaderLabel: UILabel!
    @IBOutlet private weak var logoutQotHeaderLabel: UILabel!
    @IBOutlet private weak var logoutQotTitleLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userCompanyLabel: UILabel!
    @IBOutlet private weak var userEmailLabel: UILabel!
    @IBOutlet private weak var subHeaderView: UIView!
    @IBOutlet private weak var editButton: RoundedButton!
    private weak var baseHeaderView: QOTBaseHeaderView?
    var interactor: MyQotAccountSettingsInteractor?

    private lazy var cancelAction: QOTAlertAction = {
        return QOTAlertAction(title: AppTextService.get(.generic_view_button_cancel))
    }()
    private lazy var logoutAction: QOTAlertAction = {
        let title =  AppTextService.get(.my_qot_my_profile_account_settings_alert_log_out_button_logout)
        return QOTAlertAction(title: title) { [weak self] (_) in
            let key = self?.interactor?.logoutQOTKey
            self?.trackUserEvent(.SELECT, valueType: key, action: .TAP)
            self?.interactor?.logout()
            self?.dismiss(animated: false) {}
        }
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
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
        setStatusBar(color: .black)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editProfileVC  = segue.destination as? ProfileSettingsViewController {
            ProfileSettingsConfigurator.configure(viewController: editProfileVC)
        }
    }

    // MARK: - Actions
    @IBAction func logout(_ sender: Any) {
        QOTAlert.show(title: nil,
                      message: AppTextService.get(.my_qot_my_profile_account_settings_alert_log_out_body_logout),
                      bottomItems: [cancelAction, logoutAction])
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
        baseHeaderView?.configure(title: AppTextService.get(.my_qot_my_profile_section_account_settings_title),
                                  subtitle: nil)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? .zero

        ThemeView.level3.apply(headerView)
        subHeaderView.addHeader(with: .level3)
        ThemeButton.editButton.apply(editButton)
        ThemeTint.white.apply(editButton.imageView ?? UIView.init())
        setContentForView()
    }
}

private extension MyQotAccountSettingsViewController {
    func setContentForView() {
        ThemeText.accountHeader.apply(interactor?.emailText, to: emailHeaderLabel)
        ThemeText.accountHeader.apply(interactor?.companyText, to: companyHeaderLabel)
        ThemeText.accountHeaderTitle.apply(interactor?.logoutQotText, to: logoutQotHeaderLabel)
        ThemeText.accountDetail.apply(interactor?.withoutDeletingAccountText, to: logoutQotTitleLabel)
    }

    func setDataOnView() {
        interactor?.userProfile({[weak self] (profile) in
            ThemeText.accountDetailEmail.apply(profile?.email, to: self?.userEmailLabel)
            ThemeText.accountDetailEmail.apply(profile?.company, to: self?.userCompanyLabel)
            ThemeText.accountUserName.apply(profile?.name, to: self?.userNameLabel)
        })
    }
}
