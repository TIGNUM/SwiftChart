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

final class ProfileSettingsViewController: UIViewController {

    // MARK: - Properties

    var interactor: ProfileSettingsInteractorInterface?
    private var profile: ProfileSettingsModel?
    private var tableView = UITableView()
    private var pickerItems: UserMeasurement?
    private var pickerViewHeight: NSLayoutConstraint?
    private var pickerInitialSelection = [Index]()
    private var pickerIndexPath = IndexPath(item: 0, section: 0)
    private var settingsViewModel: SettingsViewModel
    private var settingsMenuViewModel: SettingsMenuViewModel
    private let fadeContainerView = FadeContainerView()
    private let imagePickerController: ImagePickerController
    private let headerView = SettingsMenuHeader.instantiateFromNib()
    private let networkManager: NetworkManager
    private let services: Services

    private var pickerContentView: UIView = {
        let pickerContentView = UIView()
        pickerContentView.backgroundColor = .white
        return pickerContentView
    }()

    private var pickerToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barTintColor = .white
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
         settingsViewModel: SettingsViewModel) {
        self.networkManager = networkManager
        self.services = services
        self.settingsMenuViewModel = settingsMenuViewModel
        self.settingsViewModel = settingsViewModel
        imagePickerController = ImagePickerController(cropShape: .circle,
                                                      imageQuality: .low,
                                                      imageSize: .small,
                                                      permissionsManager: permissionsManager)
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
        headerView.delegate = self
        imagePickerController.delegate = self
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        syncHeader()
        registerCells()
    }
}

// MARK: - SettingsMenuViewController Interface

extension ProfileSettingsViewController: ProfileSettingsViewControllerInterface {

    func setup(profile: ProfileSettingsModel) {
        self.profile = profile
        headerDidUpdate()
    }

    func update(profile: ProfileSettingsModel) {
        if profile != self.profile {
            headerDidUpdate()
            profileDidUpdate(profile: profile)
        }
    }

    func displayImageError() {
        showAlert(type: .canNotUploadPhoto)
    }
}

// MARK: - Private

private extension ProfileSettingsViewController {

    func setupView() {
        navigationItem.title = R.string.localized.sidebarTitleProfile().uppercased()
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear

        view.addSubview(fadeContainerView)
        fadeContainerView.addSubview(tableView)
        fadeContainerView.addSubview(pickerContentView)
        pickerContentView.addSubview(pickerToolBar)
        pickerContentView.addSubview(pickerView)

        fadeContainerView.edgeAnchors == view.edgeAnchors
        tableView.edgeAnchors == fadeContainerView.edgeAnchors
        tableView.backgroundView = UIImageView(image: R.image._1_1Learn())

        pickerContentView.trailingAnchor == fadeContainerView.trailingAnchor
        pickerContentView.leadingAnchor == fadeContainerView.leadingAnchor
        pickerContentView.bottomAnchor == fadeContainerView.safeBottomAnchor
        pickerViewHeight = pickerContentView.heightAnchor == 0
        pickerToolBar.topAnchor == pickerContentView.topAnchor
        pickerToolBar.leadingAnchor == pickerContentView.leadingAnchor
        pickerToolBar.trailingAnchor == pickerContentView.trailingAnchor
        pickerToolBar.heightAnchor == 45
        pickerView.topAnchor == pickerToolBar.bottomAnchor
        pickerView.leadingAnchor == pickerContentView.leadingAnchor
        pickerView.trailingAnchor == pickerContentView.trailingAnchor
        pickerView.bottomAnchor == pickerContentView.bottomAnchor

        fadeContainerView.setFade(top: 100, bottom: 0)
        view.layoutIfNeeded()
    }

    func syncHeader() {
        let header = headerView
        header.bounds = CGRect(x: 0, y: 0, width: tableView.contentSize.width, height: 347)
        header.setNeedsLayout()
        header.layoutIfNeeded()

        var frame = header.frame
        frame.size.height = header.bounds.height
        header.frame = frame
        tableView.tableHeaderView = header
    }

    func profileDidUpdate(profile: ProfileSettingsModel) {
        headerDidUpdate()
        interactor?.saveSettingsMenu(profile)

        guard let settingsViewModel = SettingsViewModel(services: services, settingsType: .profile) else { return }
        self.settingsViewModel = settingsViewModel
        tableView.reloadData()
    }

    func headerDidUpdate() {
        guard
            let name = profile?.givenName,
            let surname = profile?.familyName,
            let position = profile?.position else { return }
        headerView.configure(imageURL: profile?.imageURL,
                             name: name + " " + surname,
                             position: position, viewModel: settingsMenuViewModel)
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
        UIView.animate(withDuration: 0.6) {
            self.pickerViewHeight?.constant = 0
        }
    }

    func showPickerView() {
        UIView.animate(withDuration: 0.6, animations: {
            self.pickerViewHeight?.constant = self.view.frame.height * 0.3
        }, completion: { finished in
            self.pickerView.selectRow(self.pickerInitialSelection[0], inComponent: 0, animated: false)
            self.pickerView.selectRow(self.pickerInitialSelection[1], inComponent: 1, animated: false)
        })
    }

    func showMultiplePicker(title: String, rows: UserMeasurement, initialSelection: [Index], indexPath: IndexPath) {
        pickerItems = rows
        pickerInitialSelection = initialSelection
        pickerIndexPath = indexPath
        showPickerView()
    }

    func showDatePicker(title: String, selectedDate: Date, indexPath: IndexPath) {
        ActionSheetDatePicker(title: title, datePickerMode: .date,
                              selectedDate: selectedDate,
                              doneBlock: { [unowned self] (_, value, _) in
                                if indexPath.section == 1 && indexPath.row == 1,
                                    let date = value as? Date {
                                    let dateOfBirth = DateFormatter.settingsUser.string(from: date)
                                    if var profile = self.profile {
                                        profile.birthday = dateOfBirth
                                        self.profileDidUpdate(profile: profile)
                                    }
                                }
            }, cancel: { (_) in
                return
        }, origin: view).show()
    }

    func showStringPicker(title: String, items: [String], selectedIndex: Index, indexPath: IndexPath) {
        ActionSheetStringPicker(title: title, rows: items, initialSelection: selectedIndex, doneBlock: { [unowned self] (_, index, _) in
            if indexPath.section == 1 && indexPath.row == 0 {
                self.profile?.gender = items[index]
                if let profile = self.profile {
                    self.profileDidUpdate(profile: profile)
                }
            }
            }, cancel: { (_) in
                return
        }, origin: view).show()
    }

    func updateUserHeightWeight() {
        guard let userMeasurement = pickerItems else { return }

        if pickerIndexPath.section == 1 {
            if pickerIndexPath.row == 2 {
                profile?.weight = userMeasurement.selectedValue
                profile?.weightUnit = userMeasurement.selectedUnit
            } else if pickerIndexPath.row == 3 {
                profile?.height = userMeasurement.selectedValue
                profile?.heightUnit = userMeasurement.selectedUnit
            }
        }
        if let profile = profile {
            profileDidUpdate(profile: profile)
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
        return settingsCell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .clear
        return footer
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch settingsViewModel.row(at: indexPath) {
        case .label(_, _, let settingsType):
            switch settingsType {
            case .logout:
                UIApplication.shared.shortcutItems?.removeAll()
                NotificationHandler.postNotification(withName: .logoutNotification)
            default: return
            }
        case .control,
             .textField: return
        case .datePicker(let title, let selectedDate, _):
            showDatePicker(title: title, selectedDate: selectedDate, indexPath: indexPath)
        case .stringPicker(let title, let pickerItems, let selectedIndex, _):
            showStringPicker(title: title, items: pickerItems, selectedIndex: selectedIndex, indexPath: indexPath)
        case .multipleStringPicker(let title, let rows, let initialSelection, _):
            showMultiplePicker(title: title, rows: rows, initialSelection: initialSelection, indexPath: indexPath)
        case .button(_, _, let settingsType):
            switch settingsType {
            case .password:
                presentResetPasswordController()
            default: return
            }
        }
    }
}

extension ProfileSettingsViewController: ResetPasswordViewControllerDelegate {

    func didTapResetPassword(withUsername username: String, completion: @escaping (NetworkError?) -> Void) {
        guard let window = AppDelegate.current.window else {
            return
        }
        let progressHUD = MBProgressHUD.showAdded(to: window, animated: true)
        networkManager.performResetPasswordRequest(username: username, completion: { error in
            progressHUD.hide(animated: true)
            completion(error)
        })
    }
}

extension ProfileSettingsViewController: SettingsViewControllerDelegate {

    func presentResetPasswordController() {
        let resetPasswordViewController = ResetPasswordViewController()
        resetPasswordViewController.delegate = self
        pushToStart(childViewController: resetPasswordViewController)
    }

    func didTextFieldChanged(at indexPath: IndexPath, text: String) {
        switch indexPath.row {
        case 1: if text.isEmpty == false { profile?.position = text }
        case 3: if text.isPhoneNumber { profile?.telephone = text }
        default: return
        }

        guard let profile = profile else { return }
        profileDidUpdate(profile: profile)
    }

    func didChangeNotificationValue(sender: UISwitch, settingsCell: SettingsTableViewCell, key: String?) {
        guard let key = key else { return }
        settingsViewModel.updateNotificationSetting(key: key, value: sender.isOn)
    }
}

// MARK: - Header delegate

extension ProfileSettingsViewController: SettingsMenuHeaderDelegate {

    func didTapImage(in view: SettingsMenuHeader) {
        imagePickerController.show(in: self)
    }
}

// MARK: - ImagePicker delegate

extension ProfileSettingsViewController: ImagePickerControllerDelegate {

    func cancelSelection() {
        
    }

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        guard let profile = profile else { return }
        interactor?.updateSettingsMenuImage(image: image, settingsMenu: profile)
        headerView.updateLocalImage(image: image)
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
