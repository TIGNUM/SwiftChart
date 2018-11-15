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

protocol SettingsViewControllerDelegate: class {
    func didTextFieldChanged(at indexPath: IndexPath, text: String)
    func didTextFieldEndEditing(at indexPath: IndexPath, text: String)
    func didChangeNotificationValue(sender: UISwitch, settingsCell: SettingsTableViewCell, key: String?)
    func didTapResetPassword(completion: @escaping (NetworkError?) -> Void)
}

final class ProfileSettingsViewController: UIViewController {

    // MARK: - Properties

    var interactor: ProfileSettingsInteractorInterface?
    private var profile: ProfileSettingsModel?
    private var tableView = UITableView(frame: .zero, style: .grouped)
    private var pickerItems: UserMeasurement?
    private var pickerViewHeight: NSLayoutConstraint?
    private var pickerToolBarHeight: NSLayoutConstraint?
    private var pickerInitialSelection = [Index]()
    private var pickerIndexPath = IndexPath(item: 0, section: 0)
    private var settingsViewModel: SettingsViewModel
    private var settingsMenuViewModel: SettingsMenuViewModel
    private let imagePickerController: ImagePickerController
    private let keyboardListener = KeyboardListener()
    private let networkManager: NetworkManager
    private let services: Services
    private var scrollViewContentHeightConstraint = NSLayoutConstraint()
    private var launchOptions: [LaunchOption: String?]

    private lazy var headerView: SettingsMenuHeader? = {
        let headerView = R.nib.settingsMenuHeader().instantiate(withOwner: nil, options: nil).first as? SettingsMenuHeader
        headerView?.delegate = self
        return headerView
    }()

    private var pickerContentView: UIView = {
        let pickerContentView = UIView()
        pickerContentView.backgroundColor = .white
        return pickerContentView
    }()

    private var pickerToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barTintColor = .navy
        let cancelButton = UIBarButtonItem(title: R.string.localized.alertButtonTitleCancel(),
                                           style: .plain,
                                           target: self,
                                           action: #selector(pickerViewCancelButtonTapped))
        let doneButton = UIBarButtonItem(title: R.string.localized.morningControllerDoneButton(),
                                         style: .plain,
                                         target: self,
                                         action: #selector(pickerViewDoneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        return toolBar
    }()

    lazy private var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

    init(configurator: Configurator<ProfileSettingsViewController>,
         services: Services,
         permissionsManager: PermissionsManager,
         networkManager: NetworkManager,
         settingsMenuViewModel: SettingsMenuViewModel,
         settingsViewModel: SettingsViewModel,
         launchOptions: [LaunchOption: String?]? = nil) {
        self.networkManager = networkManager
        self.services = services
        self.settingsMenuViewModel = settingsMenuViewModel
        self.settingsViewModel = settingsViewModel
        imagePickerController = ImagePickerController(cropShape: .rectangle,
                                                      imageQuality: .high,
                                                      imageSize: .large,
                                                      permissionsManager: permissionsManager)
        self.launchOptions = launchOptions ?? [:]
        super.init(nibName: nil, bundle: nil)
        configurator(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        imagePickerController.delegate = self
        setupView()
		syncHeader()
        scrollViewContentHeightConstraint.constant = tableView.contentInset.bottom
        keyboardListener.onStateChange { [unowned self] (state) in
            self.handleKeyboardChange(state: state)
        }
        setLaunchOptions(launchOptions)
    }

    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        syncScrollViewLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        keyboardListener.startObserving()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardListener.stopObserving()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        syncHeader()
        registerCells()
        syncScrollViewLayout()
    }
}

// MARK: - SettingsMenuViewController Interface

extension ProfileSettingsViewController: ProfileSettingsViewControllerInterface {

    func setup(profile: ProfileSettingsModel) {
        self.profile = profile
        headerDidSetup()
    }

    func update(profile: ProfileSettingsModel) {
        profileDidUpdate()
    }

    func displayImageError() {
        showAlert(type: .canNotUploadPhoto)
    }
}

// MARK: - Private

private extension ProfileSettingsViewController {

    func setupView() {
        navigationItem.title = R.string.localized.sidebarTitleProfile().uppercased()
        view.backgroundColor = .navy
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = .navy
        tableView.separatorColor = .clear
        view.addSubview(tableView)
        view.addSubview(pickerContentView)
        view.addSubview(pickerToolBar)
        view.addSubview(pickerView)
        tableView.topAnchor == view.safeTopAnchor + Layout.padding_20
        tableView.bottomAnchor == view.safeBottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
        pickerContentView.trailingAnchor == view.trailingAnchor
        pickerContentView.leadingAnchor == view.leadingAnchor
        pickerContentView.bottomAnchor == view.safeBottomAnchor + Layout.padding_32
        pickerViewHeight = pickerContentView.heightAnchor == 0
        pickerToolBar.topAnchor == pickerContentView.topAnchor
        pickerToolBar.leadingAnchor == pickerContentView.leadingAnchor
        pickerToolBar.trailingAnchor == pickerContentView.trailingAnchor
        pickerToolBarHeight = pickerToolBar.heightAnchor == 0
        pickerView.topAnchor == pickerToolBar.bottomAnchor
        pickerView.leadingAnchor == pickerContentView.leadingAnchor
        pickerView.trailingAnchor == pickerContentView.trailingAnchor
        pickerView.bottomAnchor == pickerContentView.bottomAnchor
		pickerToolBar.tintColor = .clear
        setCustomBackButton()
        view.layoutIfNeeded()
    }

    func syncScrollViewLayout() {
        let contentHeight = view.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom
        scrollViewContentHeightConstraint.constant = contentHeight
        tableView.contentInset.top = safeAreaInsets.top
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

    func syncHeader() {
        let header = headerView
        header?.bounds = CGRect(x: 0, y: 0, width: tableView.contentSize.width, height: 347)
        header?.setNeedsLayout()
        header?.layoutIfNeeded()
        var frame = header?.frame ?? .zero
        frame.size.height = header?.bounds.height ?? 0
        header?.frame = frame
        tableView.tableHeaderView = header
    }

    func profileDidUpdate() {
        guard let settingsViewModel = SettingsViewModel(services: services, settingsType: .profile) else { return }
        self.settingsViewModel = settingsViewModel
        tableView.reloadData()
    }

    func headerDidSetup() {
        headerView?.configure(imageURL: profile?.imageURL,
                              position: profile?.position ?? "",
                              viewModel: settingsMenuViewModel)
    }

    func registerCells() {
        tableView.register(R.nib.settingsLabelTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Label.identifier)
        tableView.register(R.nib.settingsButtonTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Button.identifier)
        tableView.register(R.nib.settingsControlTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Control.identifier)
        tableView.register(R.nib.settingsTextFieldTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_TextField.identifier)
    }

    func setLaunchOptions(_ options: [LaunchOption: String?]) {
        for option in options.keys {
            let value = options[option] ?? ""
            switch option {
            case .edit:
                if value?.lowercased() == "image" {
                    DispatchQueue.main.async {
                        self.didTapImage(in: nil)
                    }
                }
            }
        }
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
        UIView.animate(withDuration: 0.6) {
            self.pickerViewHeight?.constant = 0
            self.pickerToolBarHeight?.constant = 0
        }
        tableView.isUserInteractionEnabled = true
    }

    func showPickerView() {
        pickerToolBar.barTintColor = .white
		pickerToolBar.tintColor = .azure
        UIView.animate(withDuration: 0.6, animations: {
            self.pickerViewHeight?.constant = self.view.frame.height * 0.3
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
                                                guard let date = value as? Date else { return }
                                                let dateOfBirth = DateFormatter.settingsUser.string(from: date)
                                                switch self.settingsViewModel.row(at: indexPath) {
                                                case .datePicker(_, _, let settingsType):
                                                    if settingsType == .dateOfBirth, var profile = self.profile {
                                                        profile.birthday = dateOfBirth
                                                        self.interactor?.updateProfile(field: .birthday, profile: profile)
                                                    }
                                                default: return
                                                }
            }, cancel: { (_) in
                return
        }, origin: view)
        datePicker?.minimumDate = Date().minimumDateOfBirth
		datePicker?.maximumDate = Date().maximumDateOfBirth
		datePicker?.show()
    }

	func showStringPicker(title: String, items: [String], selectedIndex: Index, indexPath: IndexPath) {
		ActionSheetStringPicker(title: title, rows: items, initialSelection: selectedIndex, doneBlock: { [unowned self] (_, index, _) in
            switch self.settingsViewModel.row(at: indexPath) {
            case .stringPicker(_, _, _, let settingsType):
                if settingsType == .gender, var profile = self.profile {
                    profile.gender = items[index]
                    self.interactor?.updateProfile(field: .gender, profile: profile)
                }
            default: return
            }
		}, cancel: { (_) in
				return
		}, origin: view).show()
	}

    func updateUserHeightWeight() {
        guard let userMeasurement = pickerItems, var profile = profile else { return }
        switch self.settingsViewModel.row(at: pickerIndexPath) {
        case .multipleStringPicker(_, _, _, let settingsType):
            if settingsType == .height {
                profile.height = userMeasurement.selectedValue
                profile.heightUnit = userMeasurement.selectedUnit
                interactor?.updateProfile(field: .height, profile: profile)
            } else if settingsType == .weight {
                profile.weight = userMeasurement.selectedValue
                profile.weightUnit = userMeasurement.selectedUnit
                interactor?.updateProfile(field: .weight, profile: profile)
            }
        default:
            return
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ProfileSettingsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsViewModel.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsViewModel.numberOfItemsInSection(in: section)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = R.reuseIdentifier.settingsTableViewCell_Label.identifier
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingsTableViewCell else {
            fatalError("SettingsHeaderCell does not exist!")
        }
        headerCell.setupHeaderCell(title: settingsViewModel.headerTitle(in: section))
        return headerCell.contentView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = settingsViewModel.row(at: indexPath)
        guard let settingsCell = tableView.dequeueReusableCell(withIdentifier: row.identifier,
                                                               for: indexPath) as? SettingsTableViewCell else {
            fatalError("SettingsTableViewCell does not exist")
        }
        settingsCell.settingsDelegate = self
        settingsCell.setup(settingsRow: row, indexPath: indexPath, isSyncFinished: true)
        settingsCell.bottomSeperatorView.isHidden = false
        return settingsCell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .navy
        return footer
    }

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		switch settingsViewModel.row(at: indexPath) {
		case .control,
			 .textField: return
		case .label(_, _, let settingsType):
            switch settingsType {
            case .logout:
                showAlert(type: .logout, handlerDestructive: {
                    WidgetDataManager.didUserLogIn(false)
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
		case .button: return
		}
	}
}

// MARK: - Reset password

extension ProfileSettingsViewController {

    func didTapResetPassword(completion: @escaping (NetworkError?) -> Void) {
        guard let window = AppDelegate.current.window else { return }
        let progressHUD = MBProgressHUD.showAdded(to: window, animated: true)
        let user = services.userService.user()?.email ?? ""
        networkManager.performResetPasswordRequest(username: user, completion: { error in
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

    func didTextFieldEndEditing(at indexPath: IndexPath, text: String) {
        didTextFieldChanged(at: indexPath, text: text)
        tableView.reloadData()
    }

    func didTextFieldChanged(at indexPath: IndexPath, text: String) {
        switch indexPath.section {
        case 0:
            didChangeTextFieldInContentSection(at: indexPath, text: text)
        case 1:
            didChangeTextFieldInPersonalSection(at: indexPath, text: text)
        default: return
        }
    }

    func didChangeTextFieldInContentSection(at indexPath: IndexPath, text: String) {
        guard var profile = profile else { return }
        switch indexPath.row {
        case 1:
            if text.isTrimmedTextEmpty == false {
                profile.position = text
                interactor?.updateProfile(field: .jobTitle, profile: profile)
                headerView?.updateJobTitle(title: text)
            }
        case 3:
            profile.telephone = text
            interactor?.updateProfile(field: .telephone, profile: profile)
        default: return
        }
    }

    func didChangeTextFieldInPersonalSection(at indexPath: IndexPath, text: String) {
        guard var profile = profile else { return }
        switch indexPath.row {
        case 0: // FirstName
            if text.isTrimmedTextEmpty == false {
                profile.givenName = text
                interactor?.updateProfile(field: .givenName, profile: profile)
                headerView?.updateUserName()
            }
        case 1: // LastName
            if text.isTrimmedTextEmpty == false {
                profile.familyName = text
                interactor?.updateProfile(field: .familyName, profile: profile)
                headerView?.updateUserName()
            }
        default: return
        }
    }

    func didChangeNotificationValue(sender: UISwitch, settingsCell: SettingsTableViewCell, key: String?) {
        guard let key = key else { return }
        settingsViewModel.updateNotificationSetting(key: key, value: sender.isOn)
    }
}

// MARK: - Header delegate

extension ProfileSettingsViewController: SettingsMenuHeaderDelegate {

    func didTapImage(in view: SettingsMenuHeader?) {
        imagePickerController.show(in: self, deletable: (profile?.imageURL != nil))
        RestartHelper.setRestartURLScheme(.profile, options: [.edit: "image"])
    }
}

// MARK: - ImagePicker delegate

extension ProfileSettingsViewController: ImagePickerControllerDelegate {

    func deleteImage() {
        guard let profile = profile else { return }

        interactor?.updateSettingsMenuImage(image: nil, settingsMenu: profile)
        headerView?.updateLocalImage(image: R.image.placeholder_user() ?? UIImage())
        RestartHelper.clearRestartRouteInfo()
    }

    func cancelSelection() {
        RestartHelper.clearRestartRouteInfo()
    }

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        guard let profile = profile else { return }

        interactor?.updateSettingsMenuImage(image: image, settingsMenu: profile)
        headerView?.updateLocalImage(image: image)
        RestartHelper.clearRestartRouteInfo()
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

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let pickerItems = pickerItems else { return "" }
        return pickerItems.title(row: row, column: component)
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
