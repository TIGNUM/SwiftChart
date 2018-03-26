//
//  SettingsViewController.swift
//  QOT
//
//  Created by karmic on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import ActionSheetPicker_3_0
import UserNotifications
import UserNotificationsUI
import CoreLocation

protocol SettingsViewControllerDelegate: class {

    func didTextFieldChanged(at indexPath: IndexPath, text: String)

    func didValueChanged(at indexPath: IndexPath, sender: UISwitch, settingsCell: SettingsTableViewCell)

    func didTapPickerCell(at indexPath: IndexPath, selectedValue: String)

    func didTapButton(at indexPath: IndexPath, settingsType: SettingsType)

    func didChangeNotificationValue(sender: UISwitch, settingsCell: SettingsTableViewCell, key: String?)
}

final class SettingsViewController: UIViewController {

    // MARK: - Properties

    private var viewModel: SettingsViewModel
    private let services: Services
    private var tableView: UITableView!
    private let locationManager = CLLocationManager()
    private var pickerViewHeight: NSLayoutConstraint?
    private var destination: AppCoordinator.Router.Destination?
    private var pickerItems: UserMeasurement?
    private var pickerInitialSelection = [Index]()
    private var pickerIndexPath = IndexPath(item: 0, section: 0)
    private let fadeContainerView = FadeContainerView()
    weak var delegate: SettingsCoordinatorDelegate?
    let settingsType: SettingsType.SectionType

    lazy var pickerContentView: UIView = {
        let pickerContentView = UIView()
        pickerContentView.backgroundColor = .white
        return pickerContentView
    }()

    lazy var pickerToolBar: UIToolbar = {
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

    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

    // MARK: - Init

    init(viewModel: SettingsViewModel,
         services: Services,
         settingsType: SettingsType.SectionType,
         destination: AppCoordinator.Router.Destination?) {
        self.viewModel = viewModel
        self.settingsType = settingsType
        self.services = services
        self.destination = destination
        super.init(nibName: nil, bundle: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadTableView(_:)),
                                               name: .UIApplicationWillEnterForeground,
                                               object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        registerCells()
    }

    @available(iOS 11.0, *)
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()

        tableView.contentInset = UIEdgeInsets(top: view.safeMargins.top + Layout.statusBarHeight,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = settingsType.title.uppercased()
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard destination != nil else { return }
        delegate?.goToCalendarListViewController(settingsViewController: self, destination: destination)
        destination = nil
    }

    @objc func reloadTableView(_ notification: Notification) {
        tableView.reloadData()
    }
}

private extension SettingsViewController {

    @objc func pickerViewCancelButtonTapped(_ sender: UIBarButtonItem) {
        hidePickerView()
    }

    @objc func pickerViewDoneButtonTapped(_ sender: UIBarButtonItem) {
        updateUser()
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

    func updateUser() {
        guard let userMeasurement = pickerItems else { return }

        if pickerIndexPath.section == 1 {
            if pickerIndexPath.row == 2 {
                viewModel.updateWeight(weight: userMeasurement.selectedValue, unit: userMeasurement.selectedUnit)
            } else if pickerIndexPath.row == 3 {
                viewModel.updateHeight(meters: userMeasurement.selectedValue, unit: userMeasurement.selectedUnit)
            }
        }
        updateViewModelAndReloadTableView()
    }
}

// MARK: - Layout

private extension SettingsViewController {

    func setupView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.contentInset.top = view.safeMargins.top + Layout.statusBarHeight + Layout.paddingTop
        }

        view.addSubview(fadeContainerView)
        fadeContainerView.edgeAnchors == view.edgeAnchors
        fadeContainerView.addSubview(tableView)
        fadeContainerView.addSubview(pickerContentView)

        pickerContentView.addSubview(pickerToolBar)
        pickerContentView.addSubview(pickerView)
        tableView.backgroundView = UIImageView(image: R.image.backgroundSidebar())
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: view.safeMargins.top + Layout.statusBarHeight,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.allowsSelection = true
        tableView.rowHeight = 44
        tableView.edgeAnchors == fadeContainerView.edgeAnchors

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

        if let navigationBarHeight = navigationController?.navigationBar.bounds.height {
            fadeContainerView.setFade(top: navigationBarHeight * 1.5, bottom: 0)
        }
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

    func updateViewModelAndReloadTableView() {
        guard let settingsViewModel = SettingsViewModel(services: services, settingsType: settingsType) else {
            return
        }

        viewModel = settingsViewModel
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsRow = viewModel.row(at: indexPath)

        guard let settingsCell = tableView.dequeueReusableCell(withIdentifier: settingsRow.identifier, for: indexPath) as? SettingsTableViewCell else {
            fatalError("SettingsTableViewCell DOES NOT EXIST!!!")
        }

        settingsCell.settingsDelegate = self
        settingsCell.setup(settingsRow: settingsRow, indexPath: indexPath, isSyncFinished: true)

        return settingsCell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .clear

        return footer
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = R.reuseIdentifier.settingsTableViewCell_Label.identifier
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingsTableViewCell else {
            fatalError("HeaderCell does not exist!")
        }

        headerCell.setupHeaderCell(title: viewModel.headerTitle(in: section))

        return headerCell.contentView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedRow = viewModel.row(at: indexPath)

        switch selectedRow {
        case .button,
             .control,
             .textField: return
        case .datePicker(let title, let selectedDate, _):
            showDatePicker(title: title, selectedDate: selectedDate, indexPath: indexPath)
        case .stringPicker(let title, let pickerItems, let selectedIndex, _):
            showStringPicker(title: title, items: pickerItems, selectedIndex: selectedIndex, indexPath: indexPath)
        case .multipleStringPicker(let title, let rows, let initialSelection, _):
            showMultiplePicker(title: title, rows: rows, initialSelection: initialSelection, indexPath: indexPath)
        case .label(_, _, let settingsType):
            switch settingsType {
            case .calendar: delegate?.openCalendarListViewController(settingsViewController: self)
            case .password: delegate?.openChangePasswordViewController(settingsViewController: self)
            case .copyrights,
                 .terms,
                 .security: delegate?.openArticleViewController(viewController: self, settingsType: settingsType)
            case .tutorial: log("tutorial")
            case .interview: log("interview")
            case .support: log("support")
            case .adminSettings: delegate?.openAdminSettingsViewController(settingsViewController: self)
            default: return
            }
        }
    }
}

// MARK: - DatePicker

private extension SettingsViewController {

    func showDatePicker(title: String, selectedDate: Date, indexPath: IndexPath) {
        ActionSheetDatePicker(title: title, datePickerMode: .date,
                              selectedDate: selectedDate,
                              doneBlock: { [unowned self] (_, value, _) in
                                if indexPath.section == 1 && indexPath.row == 1,
                                    let date = value as? Date {
                                    let dateOfBirth = DateFormatter.settingsUser.string(from: date)
                                    self.viewModel.updateDateOfBirth(dateOfBirth: dateOfBirth)
                                    self.updateViewModelAndReloadTableView()
                                }
            }, cancel: { (_) in
                return
        }, origin: view).show()
    }
}

// MARK: - StringPicker

private extension SettingsViewController {

    // FIXME: IS THIS USED
    func showStringPicker(title: String, items: [String], selectedIndex: Index, indexPath: IndexPath) {
        ActionSheetStringPicker(title: title, rows: items, initialSelection: selectedIndex, doneBlock: { [unowned self] (_, index, _) in
            if indexPath.section == 1 && indexPath.row == 0 {
                self.viewModel.updateGender(gender: items[index])
            }

            self.updateViewModelAndReloadTableView()
            }, cancel: { (_) in
                return
        }, origin: view).show()
    }
}

// MARK: - MultipleStringPicker

private extension SettingsViewController {

    func showMultiplePicker(title: String,
                            rows: UserMeasurement,
                            initialSelection: [Index],
                            indexPath: IndexPath) {
        pickerItems = rows
        pickerInitialSelection = initialSelection
        pickerIndexPath = indexPath
        showPickerView()
    }
}

// MARK: - SettingsViewControllerDelegate

extension SettingsViewController: SettingsViewControllerDelegate {

    func didTextFieldChanged(at indexPath: IndexPath, text: String) {
        switch indexPath.row {
        case 1: if text.isEmpty == false { viewModel.updateJobTitle(title: text) }
        case 2: if text.isEmail { viewModel.updateEmail(email: text) }
        case 3: if text.isPhoneNumber { viewModel.updateTelephone(telephone: text) }
        default: return
        }

        self.updateViewModelAndReloadTableView()
    }

    func didTapButton(at indexPath: IndexPath, settingsType: SettingsType) {
        // Navigate to selected view, like tutorial.
    }

    func didValueChanged(at indexPath: IndexPath, sender: UISwitch, settingsCell: SettingsTableViewCell) {
        // Update ViewModel with changes.
    }

    func didTapPickerCell(at indexPath: IndexPath, selectedValue: String) {
        // Update view with nice animation and show/hide picker view.
    }

    func didTapButton(at indexPath: IndexPath) {
        // Navigate to selected view, like tutorial.
    }

    func didChangeNotificationValue(sender: UISwitch, settingsCell: SettingsTableViewCell, key: String?) {
        guard let key = key else {
            return
        }

        viewModel.updateNotificationSetting(key: key, value: sender.isOn)
    }
}

// MARK: - PickerViewDelegate, PickerViewDataSource

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {

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
        default:
            break
        }
    }
}

// MARK: - Private

private extension String {

    var isPhoneNumber: Bool {
        let phoneRegex = "^((\\+)|(00))[0-9]{6,14}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }

    var isEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}
