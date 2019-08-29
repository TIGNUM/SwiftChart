//
//  ProfileSettingsViewController.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 24/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import ActionSheetPicker_3_0
import SVProgressHUD
import qot_dal

protocol SettingsViewControllerDelegate: class {
    func didTextFieldChanged(at indexPath: IndexPath, text: String)
    func didTextFieldEndEditing(at indexPath: IndexPath, text: String)
    func didChangeNotificationValue(sender: UISwitch, settingsCell: SettingsTableViewCell, key: String?)
    func didTapResetPassword(completion: @escaping (NetworkError?) -> Void)
}

final class ProfileSettingsViewController: UITableViewController {

    // MARK: - Properties
    @IBOutlet private weak var headerTitle: UILabel!
    @IBOutlet private weak var keyboardInputView: MyQotProfileSettingsKeybaordInputView!

    var shouldAllowSave: Bool = false {
        willSet {
            keyboardInputView.shouldAllowSave = newValue
        }
    }

    private var selectedCell: SettingsTableViewCell?
    private var genderPickerItems: [String] = []
    private var pickerItems: UserMeasurement?
    private var pickerViewHeight: NSLayoutConstraint?
    private var pickerInitialSelection = [Index]()
    private var pickerIndexPath = IndexPath(item: 0, section: 0)

    var interactor: ProfileSettingsInteractorInterface?
    var networkManager: NetworkManager!
    var launchOptions: [LaunchOption: String?]?

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
        registerCells()
        interactor?.editAccountTitle({[weak self] (text) in
            self?.headerTitle.text = text
        })
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
        let dateOfBirth = DateFormatter.settingsUser.string(from: sender.date)
        interactor?.profile?.dateOfBirth = dateOfBirth
        selectedCell?.textField.text = dateOfBirth
    }

    func showDatePicker(title: String, selectedDate: Date, indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SettingsTableViewCell else {
            return
        }
        selectedCell = cell
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = .carbonDark
        datePicker.setValue(UIColor.sand, forKeyPath: "textColor")
        datePicker.datePickerMode = .date
        datePicker.setDate(selectedDate, animated: true)
        datePicker.minimumDate = Date().minimumDateOfBirth
        datePicker.maximumDate = Date().maximumDateOfBirth
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        cell.textField.inputView = datePicker
        cell.textField.becomeFirstResponder()
    }

	func showStringPicker(title: String, items: [String], selectedIndex: Index, indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SettingsTableViewCell else {
            return
        }
        genderPickerItems = items
        selectedCell = cell
        let picker = UIPickerView()
        picker.delegate = self
        picker.backgroundColor = .carbonDark
        cell.textField.inputView = picker
        cell.textField.becomeFirstResponder()
	}

    func updateUserHeightWeight() {
        guard let userMeasurement = pickerItems, var interactor = self.interactor else { return }
        switch interactor.row(at: pickerIndexPath) {
        case .multipleStringPicker(_, _, _, let settingsType):
            if settingsType == .height {
                interactor.profile?.height = userMeasurement.selectedValue
                interactor.profile?.heightUnit = userMeasurement.selectedUnit
                reloadData()
            } else if settingsType == .weight {
                interactor.profile?.weight = userMeasurement.selectedValue
                interactor.profile?.weightUnit = userMeasurement.selectedUnit
                reloadData()
            }
        default:
            return
        }
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
                showAlert(type: .logout, handlerDestructive: {
                    ExtensionsDataManager.didUserLogIn(false)
                    UIApplication.shared.shortcutItems?.removeAll()
                    NotificationHandler.postNotification(withName: .logoutNotification)
                })
            case .password:
                showAlert(type: .changePassword, handlerDestructive: {
                    self.resetPassword()
                })
            default: return
            }
        case .datePicker(let title, let selectedDate, _):
            showDatePicker(title: title, selectedDate: selectedDate, indexPath: indexPath)
        case .stringPicker(let title, let pickerItems, let selectedIndex, _):
            showStringPicker(title: title, items: pickerItems, selectedIndex: selectedIndex, indexPath: indexPath)
        case .multipleStringPicker:
            break
        default:
            break
        }
    }
}

// MARK: - Reset password
extension ProfileSettingsViewController {
    func didTapResetPassword(completion: @escaping (NetworkError?) -> Void) {
        SVProgressHUD.show()
        let userEmail = interactor?.profile?.email ?? ""
        networkManager.performResetPasswordRequest(username: userEmail, completion: { error in
            SVProgressHUD.dismiss()
            completion(error)
        })
    }

    func resetPassword() {
        didTapResetPassword (completion: { error in
            if let error = error {
                switch error.type {
                case .noNetworkConnection:
                    self.showAlert(type: .noNetworkConnection)
                case .notFound:
                    self.showAlert(type: .emailNotFound)
                default:
                    self.showAlert(type: .unknown)
                }
                return
            }

            self.showAlert(type: .resetPassword)
        })
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
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension ProfileSettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderPickerItems.count
    }

   func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title =  genderPickerItems[row]
        let myTitle = NSAttributedString(string: title, attributes: [.foregroundColor: UIColor.sand])
        return myTitle
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = genderPickerItems[row]
        selectedCell?.textField.text = selectedValue
        interactor?.profile?.gender = selectedValue
        shouldAllowSave = true
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
        interactor?.updateUser(profile)
        dismiss()
    }

    func dismiss() {
        guard let navController = self.navigationController else { return }
        navController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - PopUpViewControllerProtocol
extension ProfileSettingsViewController: PopUpViewControllerProtocol {
    func leftButtonAction() {
        interactor?.closeUpdateConfirmationScreen(completion: { [weak self] in
            self?.trackUserEvent(.CANCEL, action: .TAP)
        })
    }

    func rightButtonAction() {
        trackUserEvent(.YES_LEAVE, action: .TAP)
        interactor?.closeUpdateConfirmationScreen(completion: { [weak self] in
            self?.didPressLeave()
        })
    }

    func cancelAction() {
        interactor?.closeUpdateConfirmationScreen(completion: { [weak self] in
            self?.trackUserEvent(.CANCEL, action: .TAP)
        })
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
