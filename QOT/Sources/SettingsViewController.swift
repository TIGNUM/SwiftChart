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

    func didValueChanged(at indexPath: IndexPath, sender: UISwitch, settingsCell: SettingsTableViewCell)

    func didTapPickerCell(at indexPath: IndexPath, selectedValue: String)

    func didTapButton(at indexPath: IndexPath, settingsType: SettingsType)

    func didChangeLocationValue(sender: UISwitch, settingsCell: SettingsTableViewCell)

    func didChangeNotificationValue(sender: UISwitch, settingsCell: SettingsTableViewCell, key: String?)
}

final class SettingsViewController: UIViewController {

    // MARK: - Properties

    fileprivate var viewModel: SettingsViewModel
    fileprivate let services: Services
    fileprivate let locationManager = CLLocationManager()
    weak var delegate: SettingsCoordinatorDelegate?
    let settingsType: SettingsType.SectionType
    var tableView: UITableView!

    // MARK: - Init
    
    init(viewModel: SettingsViewModel, services: Services, settingsType: SettingsType.SectionType) {
        self.viewModel = viewModel
        self.settingsType = settingsType
        self.services = services

        super.init(nibName: nil, bundle: nil)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
}

// MARK: - Layout

private extension SettingsViewController {
    
    func setupView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView)
        view.backgroundColor = .clear
        view.applyFade()

        tableView.backgroundView = UIImageView(image: R.image.backgroundSidebar())
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 110, left: 0, bottom: 64, right: 0)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.allowsSelection = true
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.horizontalAnchors == view.horizontalAnchors
        tableView.verticalAnchors == view.verticalAnchors
    }

    func registerCells() {
        tableView.register(R.nib.settingsLabelTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Label.identifier)
        tableView.register(R.nib.settingsButtonTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Button.identifier)
        tableView.register(R.nib.settingsControlTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Control.identifier)
        tableView.register(R.nib.settingsTextFieldTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_TextField.identifier)
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
        settingsCell.setup(settingsRow: settingsRow, indexPath: indexPath)

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
                 .legalNotes,
                 .terms,
                 .security,
                 .dataProtection: delegate?.openArticleViewController(viewController: self, settingsType: settingsType)
            case .tutorial: print("tutorial")
            case .interview: print("interview")
            case .support: print("support")
            default: return
            }
        }
    }
}

// MARK: - DatePicker

private extension SettingsViewController {

    func showDatePicker(title: String, selectedDate: Date, indexPath: IndexPath) {
        let picker = createDatePicker(with: title, selectedDate: selectedDate, indexPath: indexPath)
        self.setupPickerButtons(picker: picker)
        picker.show()
    }

    private func createDatePicker(with title: String, selectedDate: Date, indexPath: IndexPath) -> ActionSheetDatePicker {
        return ActionSheetDatePicker(title: title, datePickerMode: .date,
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
        }, origin: view)
    }
}

// MARK: - StringPicker

private extension SettingsViewController {

    func showStringPicker(title: String, items: [String], selectedIndex: Index, indexPath: IndexPath) {
        let picker = createStringPicker(with: title, items: items, selectedIndex: selectedIndex, indexPath: indexPath)
        self.setupPickerButtons(picker: picker)
        picker.show()
    }

    private func createStringPicker(with title: String, items: [String], selectedIndex: Index, indexPath: IndexPath) -> ActionSheetStringPicker {
        return ActionSheetStringPicker(title: title, rows: items, initialSelection: selectedIndex, doneBlock: { [unowned self] (_, index, _) in
            if indexPath.section == 1 && indexPath.row == 0 {
                self.viewModel.updateGender(gender: items[index])
            } else if indexPath.section == 1 && indexPath.row == 2 {
                self.viewModel.updateWeight(weight: items[index])
            } else if indexPath.section == 1 && indexPath.row == 3 {
                self.viewModel.updateHeight(height: items[index])
            }

            self.updateViewModelAndReloadTableView()
        }, cancel: { (_) in
            return
        }, origin: view)
    }

    func setupPickerButtons(picker: AbstractActionSheetPicker) {
        picker.setDoneButton(UIBarButtonItem(title: "Done", style: .done, target: self, action: nil))
        picker.setCancelButton(UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil))
    }
}

// MARK: - MultipleStringPicker

private extension SettingsViewController {

    func showMultiplePicker(title: String, rows: [[String]], initialSelection: [Index], indexPath: IndexPath) {
        let picker = multipleStringPicker(title: title, rows: rows, initialSelection: initialSelection, indexPath: indexPath)
        self.setupPickerButtons(picker: picker)
        picker.show()
    }

    private func multipleStringPicker(title: String, rows: [[String]], initialSelection: [Index], indexPath: IndexPath) -> ActionSheetMultipleStringPicker {
        return ActionSheetMultipleStringPicker(title: title, rows: rows, initialSelection: initialSelection, doneBlock: { (_, _, value) in
            if indexPath.section == 1 {
                if indexPath.row == 2,
                    let weightComponents = value as? [String] {
                        let weight = String(format: "%@", weightComponents[0])
                        self.viewModel.updateWeight(weight: weight)
                        self.viewModel.updateWeightUnit(weightUnit: weightComponents[1])
                } else if indexPath.row == 3,
                    let heightComponents = value as? [String] {
                        let height = String(format: "%@", heightComponents[0])
                        self.viewModel.updateHeight(height: height)
                        self.viewModel.updateHeightUnit(heightUnit: heightComponents[1])
                }
            }

            self.updateViewModelAndReloadTableView()
        }, cancel: { (_) in
            return
        }, origin: view)
    }
}

// MARK: - SettingsViewControllerDelegate

extension SettingsViewController: SettingsViewControllerDelegate {

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

    func didChangeLocationValue(sender: UISwitch, settingsCell: SettingsTableViewCell) {        
        if LocationManager.authorizationStatus == .notDetermined {
            // TODO: Connect with PremissionManager and requesst for the very first time.            
            resetLocationSwitch(sender: sender, settingsCell: settingsCell)
            locationManager.requestWhenInUseAuthorization()
        } else if LocationManager.authorizationStatus == .denied || LocationManager.authorizationStatus == .restricted {
            resetLocationSwitch(sender: sender, settingsCell: settingsCell)
            showAlert(type: .settingsLoccationService, handler: { 
                UIApplication.openAppSettings()
            }, handlerDestructive: nil)
        } else {
            UserDefault.locationService.setBoolValue(value: sender.isOn)
            settingsCell.controlUpdate = false
            settingsCell.setSwitchState(switchControl: sender)
        }
    }

    private func resetLocationSwitch(sender: UISwitch, settingsCell: SettingsTableViewCell) {
        sender.isOn = false
        settingsCell.setSwitchState(switchControl: sender)
        settingsCell.controlUpdate = false
    }
}
