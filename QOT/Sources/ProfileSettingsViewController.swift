//
//  ProfileSettingsViewController.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 24/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import SVProgressHUD
import qot_dal

protocol SettingsViewControllerDelegate: class {
    func didTextFieldChanged(at indexPath: IndexPath, text: String)
    func didTextFieldEndEditing(at indexPath: IndexPath, text: String)
    func didChangeNotificationValue(sender: UISwitch, settingsCell: SettingsTableViewCell, key: String?)
}

final class ProfileSettingsViewController: UITableViewController, ScreenZLevel3 {

    // MARK: - Properties
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var keyboardInputView: MyQotProfileSettingsKeybaordInputView!
    private var selectedCell: SettingsTableViewCell?
    var interactor: ProfileSettingsInteractorInterface?
    var launchOptions: [LaunchOption: String?]?

    var shouldAllowSave: Bool = false {
        willSet {
            keyboardInputView.shouldAllowSave = newValue
        }
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(color: .black)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }
}

// MARK: - SettingsMenuViewController Interface
extension ProfileSettingsViewController: ProfileSettingsViewControllerInterface {
    func setup(profile: QDMUser) {
        tableView.reloadData()
    }
}

// MARK: - Private
private extension ProfileSettingsViewController {
    func didPressLeave() {
        trackUserEvent(.YES_LEAVE, action: .TAP)
        dismiss()
    }

    func setupView() {
        NewThemeView.dark.apply(view)
        tableView.tableFooterView = UIView()
        registerCells()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        baseHeaderView?.configure(title: interactor?.editAccountTitle, subtitle: nil)
        keyboardInputView.delegate = self
    }

    func registerCells() {
        tableView.register(UINib(resource: R.nib.settingsLabelTableViewCell),
                           forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Label.identifier)
        tableView.register(UINib(resource: R.nib.settingsButtonTableViewCell),
                           forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Button.identifier)
        tableView.register(UINib(resource: R.nib.settingsControlTableViewCell),
                           forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Control.identifier)
        tableView.register(UINib(resource: R.nib.settingsTextFieldTableViewCell),
                           forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_TextField.identifier)
        tableView.registerDequeueable(TitleTableHeaderView.self)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProfileSettingsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return interactor?.numberOfSections() ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.numberOfItemsInSection(in: section) ?? 0
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: TitleTableHeaderView = tableView.dequeueHeaderFooter()
        headerView.configure(title: interactor?.headerTitle(in: section) ?? "", theme: .level3)
        return headerView
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let interactor = self.interactor else {
            fatalError("Interactor does not exist")
        }
        let row = interactor.row(at: indexPath)
        guard let settingsCell = tableView.dequeueReusableCell(withIdentifier: row.identifier,
                                                               for: indexPath) as? SettingsTableViewCell else {
            fatalError("SettingsTableViewCell does not exist")
        }
        settingsCell.settingsDelegate = self
        settingsCell.keyboardInputView = keyboardInputView
        settingsCell.setup(settingsRow: row, indexPath: indexPath, isSyncFinished: true)
        return settingsCell
    }
}

// MARK: - SettingsViewControllerDelegate
extension ProfileSettingsViewController: SettingsViewControllerDelegate {
    func didChangeNotificationValue(sender: UISwitch, settingsCell: SettingsTableViewCell, key: String?) {

    }

    func didTextFieldEndEditing(at indexPath: IndexPath, text: String) {
        didTextFieldChanged(at: indexPath, text: text)
    }

    func didTextFieldChanged(at indexPath: IndexPath, text: String) {
        switch indexPath.section {
        case 0:
            didChangeTextFieldInPersonalSection(at: indexPath, text: text)
        case 1:
            didChangeTextFieldInContentSection(at: indexPath, text: text)
        default: return
        }
    }

    func reloadData() {
        interactor?.generateSections()
        tableView.reloadData()
    }

    func didChangeTextFieldInContentSection(at indexPath: IndexPath, text: String) {
        switch indexPath.row {
        case 1:
            if text.isTrimmedTextEmpty == false {
                interactor?.profile?.jobTitle = text
                interactor?.generateSections()
            }
        case 3:
             interactor?.profile?.telephone = text
             interactor?.generateSections()
        default: return
        }
    }

    func didChangeTextFieldInPersonalSection(at indexPath: IndexPath, text: String) {
        switch indexPath.row {
        case 0: // FirstName
            if interactor?.profile?.givenName != text {
                interactor?.profile?.givenName = text
                interactor?.generateSections()
                shouldAllowSave = text != ""
            }
        case 1: // LastName
                if interactor?.profile?.familyName != text {
                interactor?.profile?.familyName = text
                interactor?.generateSections()
                shouldAllowSave = text != ""
                }
        default: return
        }
    }

    func presentAlert(title: String, message: String, cancelTitle: String, doneTitle: String) {

        let cancelHandler: (() -> Void) = { [weak self] in
            self?.trackUserEvent(.CANCEL, action: .TAP)
        }
        let cancel = QOTAlertAction(title: cancelTitle) { (_) in
            cancelHandler()
        }
        let done = QOTAlertAction(title: doneTitle) { [weak self] (_) in
            self?.trackUserEvent(.YES_LEAVE, action: .TAP)
            self?.didPressLeave()
        }
        QOTAlert.show(title: title, message: message, bottomItems: [cancel, done], cancelHandler: cancelHandler)
    }
}

// MARK: - MyQotProfileSettingsKeybaordInputViewProtocol
extension ProfileSettingsViewController: MyQotProfileSettingsKeybaordInputViewProtocol {
    @objc func didCancel() {
        view.endEditing(true)
        if shouldAllowSave {
            interactor?.showUpdateConfirmationScreen()
        } else {
            dismiss()
        }
    }

    @objc func didSave() {
        guard let profile = interactor?.profile, shouldAllowSave else { return }
        trackUserEvent(.CONFIRM, action: .TAP)
        interactor?.updateUser(profile) { [weak self] in
            self?.dismiss()
        }
    }

    func dismiss() {
        guard let navController = self.navigationController else { return }
        navController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - BottomNavigation
extension ProfileSettingsViewController {
    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        let cancelItem = roundedBarButtonItem(title: AppTextService.get(.generic_view_button_cancel),
                                              buttonWidth: .Cancel,
                                              action: #selector(didCancel),
                                              backgroundColor: .black,
                                              borderColor: .accent40)
        let saveItem = saveButtonItem(#selector(didSave))
        return [saveItem, cancelItem]
    }
}
