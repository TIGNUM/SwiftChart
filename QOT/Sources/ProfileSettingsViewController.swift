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
import MBProgressHUD
import qot_dal

protocol SettingsViewControllerDelegate: class {
    func didTextFieldChanged(at indexPath: IndexPath, text: String)
    func didTextFieldEndEditing(at indexPath: IndexPath, text: String)
    func didChangeNotificationValue(sender: UISwitch, settingsCell: SettingsTableViewCell, key: String?)
    func didTapResetPassword(completion: @escaping (NetworkError?) -> Void)
}

final class ProfileSettingsViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var pickerToolBar: UIToolbar!
    @IBOutlet private weak var pickerView: UIPickerView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var pickerContentView: UIView!
    @IBOutlet private weak var headerTitle: UILabel!

    var shouldAllowSave: Bool = false {
        didSet {
            if footerView?.isEnabled == true { return }
            footerView?.setupView(isEnabled: true)
        }
    }

    private var pickerItems: UserMeasurement?
    private var pickerViewHeight: NSLayoutConstraint?
    private var pickerToolBarHeight: NSLayoutConstraint?
    private var pickerInitialSelection = [Index]()
    private var pickerIndexPath = IndexPath(item: 0, section: 0)
    private let keyboardListener = KeyboardListener()
    private var scrollViewContentHeightConstraint = NSLayoutConstraint()

    var interactor: ProfileSettingsInteractorInterface?
    var networkManager: NetworkManager!
    var launchOptions: [LaunchOption: String?]?

    private var footerView: ProfileSettingsFooterView? = {
    let footerView = UINib(resource: R.nib.profileSettingsFooterView).instantiate(withOwner: nil, options: nil).first as? ProfileSettingsFooterView
        return footerView
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        setupView()
        scrollViewContentHeightConstraint.constant = tableView.contentInset.bottom
        keyboardListener.onStateChange { [unowned self] (state) in
            self.handleKeyboardChange(state: state)
        }
    }

    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        syncScrollViewLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardListener.startObserving()
        UIApplication.shared.statusBarView?.backgroundColor = .carbon
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardListener.stopObserving()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        registerCells()
        syncScrollViewLayout()
    }
}

// MARK: - SettingsMenuViewController Interface

extension ProfileSettingsViewController: ProfileSettingsViewControllerInterface {

    func setup(profile: QDMUser) {
        tableView.tableFooterView = footerView
        tableView.reloadData()
    }
}

// MARK: - Private

private extension ProfileSettingsViewController {

    func setupView() {
        interactor?.editAccountTitle({[weak self] (text) in
            self?.headerTitle.text = text
        })
        footerView?.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)
        footerView?.autoresizingMask = .flexibleWidth
        footerView?.setupView(isEnabled: false)
        footerView?.delegate = self
        view.backgroundColor = .carbon
        pickerToolBar.tintColor = .clear
        pickerToolBar.barTintColor = .clear
        pickerViewHeight = pickerContentView.heightAnchor == 0
        pickerToolBarHeight = pickerToolBar.heightAnchor == 0
        let cancelButton = UIBarButtonItem(title: R.string.localized.alertButtonTitleCancel(),
                                           style: .plain,
                                           target: self,
                                           action: #selector(pickerViewCancelButtonTapped))
        let doneButton = UIBarButtonItem(title: R.string.localized.morningControllerDoneButton(),
                                         style: .plain,
                                         target: self,
                                         action: #selector(pickerViewDoneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        pickerToolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        pickerView.showsSelectionIndicator = true
        setCustomBackButton()
    }

    func syncScrollViewLayout() {
        let contentHeight = view.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom
        scrollViewContentHeightConstraint.constant = contentHeight
        let spaceBellowCollectionView = contentHeight - tableView.frame.maxY
        let bottomInset = max(keyboardListener.state.height - spaceBellowCollectionView, safeAreaInsets.bottom)
        tableView.contentInset.bottom = bottomInset
    }

    func handleKeyboardChange(state: KeyboardListener.State) {
        switch state {
        case .idle:
            break
        case .willChange(_, _, let duration, let curve):
            syncScrollViewLayout()
            let options = UIViewAnimationOptions(curve: curve)
            let contentHeight = scrollViewContentHeightConstraint.constant
            let minY = tableView.contentInset.top
            let yPos = max(contentHeight - tableView.bounds.height + tableView.contentInset.bottom, -minY)
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.tableView.contentOffset.y = yPos
            })
        }
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

    @objc func pickerViewCancelButtonTapped(_ sender: UIBarButtonItem) {
        hidePickerView()
    }

    @objc func pickerViewDoneButtonTapped(_ sender: UIBarButtonItem) {
        updateUserHeightWeight()
        hidePickerView()
    }

    func hidePickerView() {
        pickerToolBar.barTintColor = .clear
		pickerToolBar.tintColor = .clear
        pickerView.backgroundColor = .clear
        UIView.animate(withDuration: 0.6) {
            self.pickerViewHeight?.constant = 0
            self.pickerToolBarHeight?.constant = 0
        }
        tableView.isUserInteractionEnabled = true
    }

    func showPickerView() {
        pickerView.reloadAllComponents()
        pickerToolBar.barTintColor = .carbonDark
        pickerToolBar.isTranslucent = true
		pickerToolBar.tintColor = .sand
        pickerView.backgroundColor = .carbonDark
        UIView.animate(withDuration: 0.6, animations: {
            self.pickerViewHeight?.constant = self.view.frame.height * (self.screenType == .small ? 0.5 : 0.3)
            self.pickerToolBarHeight?.constant = Layout.height_44
        }, completion: { finished in
            self.pickerView.selectRow(self.pickerInitialSelection[0], inComponent: 0, animated: false)
            self.pickerView.selectRow(self.pickerInitialSelection[1], inComponent: 1, animated: false)
        })
        tableView.isUserInteractionEnabled = false
    }

    func showMultiplePicker(title: String, rows: UserMeasurement, initialSelection: [Index], indexPath: IndexPath) {
        pickerItems = rows
        pickerInitialSelection = initialSelection
        pickerIndexPath = indexPath
        showPickerView()
    }

    func showDatePicker(title: String, selectedDate: Date, indexPath: IndexPath) {
        let datePicker = ActionSheetDatePicker(title: title, datePickerMode: .date,
                                               selectedDate: selectedDate,
                                               doneBlock: { [unowned self] (_, value, _) in
                                                guard let date = value as? Date, var interactor = self.interactor else { return }
                                                let dateOfBirth = DateFormatter.settingsUser.string(from: date)
                                                switch interactor.row(at: indexPath) {
                                                case .datePicker(_, _, let settingsType):
                                                    if settingsType == .dateOfBirth {
                                                        interactor.profile?.dateOfBirth = dateOfBirth
                                                        self.reloadData()
                                                        self.shouldAllowSave = true
                                                    }
                                                default: return
                                                }
            }, cancel: { (_) in
                return
        }, origin: view)
        datePicker?.pickerBackgroundColor = .carbonDark
        datePicker?.toolbarBackgroundColor = .carbonDark
        datePicker?.toolbarButtonsColor = .sand
        datePicker?.setTextColor(.sand)
        datePicker?.minimumDate = Date().minimumDateOfBirth
		datePicker?.maximumDate = Date().maximumDateOfBirth
		datePicker?.show()
    }

	func showStringPicker(title: String, items: [String], selectedIndex: Index, indexPath: IndexPath) {
		 let genderPicker = ActionSheetStringPicker(title: title, rows: items, initialSelection: selectedIndex, doneBlock: { [unowned self] (_, index, _) in
            switch self.interactor?.row(at: indexPath) {
            case .stringPicker(_, _, _, let settingsType)?:
                if settingsType == .gender {
                    self.interactor?.profile?.gender = items[index]
                    self.reloadData()
                    self.shouldAllowSave = true
                }
            default: return
            }
		}, cancel: { (_) in
				return
		}, origin: view)

        genderPicker?.pickerBackgroundColor = .carbonDark
        genderPicker?.toolbarBackgroundColor = .carbonDark
        genderPicker?.toolbarButtonsColor = .sand
        genderPicker?.setTextColor(.sand)
        genderPicker?.show()
	}

    func updateUserHeightWeight() {
        guard let userMeasurement = pickerItems, var interactor = self.interactor else { return }
        switch interactor.row(at: pickerIndexPath) {
        case .multipleStringPicker(_, _, _, let settingsType):
            if settingsType == .height {
                interactor.profile?.height = userMeasurement.selectedValue
                interactor.profile?.heightUnit = userMeasurement.selectedUnit
                reloadData()
                shouldAllowSave = true
            } else if settingsType == .weight {
                interactor.profile?.weight = userMeasurement.selectedValue
                interactor.profile?.weightUnit = userMeasurement.selectedUnit
                reloadData()
                shouldAllowSave = true
            }
        default:
            return
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ProfileSettingsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor?.numberOfSections() ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.numberOfItemsInSection(in: section) ?? 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: TitleTableHeaderView = tableView.dequeueHeaderFooter()
        headerView.config = TitleTableHeaderView.Config(backgroundColor: .carbon)
        headerView.title = interactor?.headerTitle(in: section) ?? ""
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let interactor = self.interactor else {
            fatalError("Interactor does not exist")
        }
        let row = interactor.row(at: indexPath)
        guard let settingsCell = tableView.dequeueReusableCell(withIdentifier: row.identifier,
                                                               for: indexPath) as? SettingsTableViewCell else {
            fatalError("SettingsTableViewCell does not exist")
        }
        settingsCell.settingsDelegate = self
        settingsCell.setup(settingsRow: row, indexPath: indexPath, isSyncFinished: true)
        return settingsCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        case .multipleStringPicker(let title, let rows, let initialSelection, _):
            showMultiplePicker(title: title, rows: rows, initialSelection: initialSelection, indexPath: indexPath)
        default:
            break
        }
    }
}

// MARK: - Reset password

extension ProfileSettingsViewController {

    func didTapResetPassword(completion: @escaping (NetworkError?) -> Void) {
        guard let window = AppDelegate.current.window else { return }
        let progressHUD = MBProgressHUD.showAdded(to: window, animated: true)
        let userEmail = interactor?.profile?.email ?? ""
        networkManager.performResetPasswordRequest(username: userEmail, completion: { error in
            progressHUD.hide(animated: true)
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
                shouldAllowSave = true
            }
        case 3:
             interactor?.profile?.telephone = text
             interactor?.generateSections()
             shouldAllowSave = true
        default: return
        }
    }

    func didChangeTextFieldInPersonalSection(at indexPath: IndexPath, text: String) {
        switch indexPath.row {
        case 0: // FirstName
            if text.isTrimmedTextEmpty == false {
                 interactor?.profile?.givenName = text
                interactor?.generateSections()
                shouldAllowSave = true
            }
        case 1: // LastName
            if text.isTrimmedTextEmpty == false {
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
        guard let pickerItems = pickerItems else { return 0 }
        return pickerItems.columnCount
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let pickerItems = pickerItems else { return 0 }
        return pickerItems.rowCount(column: component)
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let pickerItems = pickerItems else { return NSAttributedString(string: "", attributes: nil)  }
        let title =  pickerItems.title(row: row, column: component)
        let myTitle = NSAttributedString(string: title ?? "", attributes: [.foregroundColor: UIColor.sand])
        return myTitle
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerInitialSelection = [pickerView.selectedRow(inComponent: 0), pickerView.selectedRow(inComponent: 1)]
        guard let pickerItems = pickerItems else { return }

        let optionIndex = pickerView.selectedRow(inComponent: 1)
        let unit = pickerItems.options[optionIndex].unit

        switch component {
        case 0:
            pickerItems.update(valueIndex: row)
        case 1:
            pickerItems.update(unit: unit)
            pickerView.reloadAllComponents()
            pickerView.selectRow(pickerItems.valueIndex, inComponent: 0, animated: false)
        default: break
        }
    }
}

extension ProfileSettingsViewController: ProfileSettingsFooterViewProtocol {
    func didSave() {
        guard let profile = interactor?.profile else { return }
        trackUserEvent(.CONFIRM, action: .TAP)
        interactor?.updateUser(profile)
        guard let navController = self.navigationController else { return }
        navController.dismiss(animated: true, completion: nil)
    }

    func didCancel() {
        guard let navController = self.navigationController else { return }
        trackUserEvent(.CANCEL, action: .TAP)
        navController.dismiss(animated: true, completion: nil)
    }
}

extension ProfileSettingsViewController {
    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc override public func bottomNavigationBackgroundColor() -> UIColor? {
        return .clear
    }
}
