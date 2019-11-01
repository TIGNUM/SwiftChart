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

    private var localizedYear = AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_view_title_year_select)

    private lazy var yearPickerItems: [String] = {
        var items = [String]()
        let minYear = Date().minimumDateOfBirth.year()
        let maxYear = Date().maximumDateOfBirth.year()

        for year in minYear...maxYear {
            items.append(String(year))
        }

        items.reverse()
        items.insert(localizedYear, at: 0)
        return items
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = .carbon
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
        tableView.tableFooterView = UIView()
        registerCells()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        baseHeaderView?.configure(title: interactor?.editAccountTitle, subtitle: nil)
        view.backgroundColor = .carbon
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

// MARK: - Private PickerView
extension ProfileSettingsViewController {
    @objc func dateChanged(_ sender: UIDatePicker) {
        shouldAllowSave = true
        let dateOfBirth = DateFormatter.yyyyMMdd.string(from: sender.date)
        interactor?.profile?.dateOfBirth = dateOfBirth
        selectedCell?.textField.text = dateOfBirth
    }

    func showDatePicker(title: String, selectedYear: String, indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SettingsTableViewCell else {
            return
        }
        selectedCell = cell
        let yearPicker = UIPickerView()
        yearPicker.backgroundColor = .carbonDark
        yearPicker.setValue(UIColor.sand, forKeyPath: "textColor")
        yearPicker.dataSource = self
        yearPicker.delegate = self
        let row = (yearPickerItems.index(of: selectedYear) ?? 0)
        yearPicker.selectRow(row, inComponent: 0, animated: true)
        cell.textField.inputView = yearPicker
        cell.textField.becomeFirstResponder()
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let interactor = self.interactor else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        switch interactor.row(at: indexPath) {
        case .label(_, _, let settingsType):
            switch settingsType {
            case .logout:
                let cancel = QOTAlertAction(title: AppTextService.get(AppTextKey.generic_view_button_cancel))
                let logout = QOTAlertAction(title: AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_button_logout)) { (_) in
                    ExtensionsDataManager.didUserLogIn(false)
                    UIApplication.shared.shortcutItems?.removeAll()
                    NotificationHandler.postNotification(withName: .logoutNotification)
                }
                QOTAlert.show(title: nil, message: AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_alert_body_logout), bottomItems: [cancel, logout])
            default: return
            }
        case .datePicker(let title, let selectedYear, _):
            showDatePicker(title: title, selectedYear: selectedYear, indexPath: indexPath)
        default:
            break
        }
    }
}

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
                shouldAllowSave = true
            }
        case 1: // LastName
            if interactor?.profile?.familyName != text {
                 interactor?.profile?.familyName = text
                interactor?.generateSections()
                shouldAllowSave = true
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

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension ProfileSettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearPickerItems.count
    }

   func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title =  yearPickerItems[row]
        let myTitle = NSAttributedString(string: title, attributes: [.foregroundColor: UIColor.sand])
        return myTitle
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = yearPickerItems[row]
        if selectedValue != localizedYear {
            selectedCell?.textField.text = selectedValue
            let selectedDate = DateFormatter.yyyyMMdd.date(from: selectedValue+"-01-02")
            interactor?.profile?.dateOfBirth = DateFormatter.yyyyMMdd.string(from: selectedDate ?? Date())
            shouldAllowSave = true
        }
    }
}

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
        let cancelItem = cancelButtonItem(#selector(didCancel))
        let saveItem = saveButtonItem(#selector(didSave))
        return [saveItem, cancelItem]
    }
}
