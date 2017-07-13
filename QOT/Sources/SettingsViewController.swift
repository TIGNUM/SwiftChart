//
//  SettingsViewController.swift
//  QOT
//
//  Created by karmic on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import UserNotifications
import UserNotificationsUI

protocol SettingsViewControllerDelegate: class {

    func didValueChanged(at indexPath: IndexPath, enabled: Bool)

    func didTapPickerCell(at indexPath: IndexPath, selectedValue: String)

    func didTapButton(at indexPath: IndexPath)

    func updateViewModelAndReload(viewController: SettingsViewController)
}

final class SettingsViewController: UITableViewController {

    // MARK: - Properties

    fileprivate var viewModel: SettingsViewModel
    fileprivate let settingsType: SettingsViewModel.SettingsType
    weak var delegate: SettingsViewControllerDelegate?
    
    // MARK: - Init
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        self.settingsType = viewModel.settingsType

        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        setupView()
    }

    func update(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
}

// MARK: - Layout

private extension SettingsViewController {
    
    func setupView() {
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 64, right: 0)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.allowsSelection = true
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    func registerCells() {
        tableView.register(R.nib.settingsLabelTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Label.identifier)
        tableView.register(R.nib.settingsButtonTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Button.identifier)
        tableView.register(R.nib.settingsControlTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Control.identifier)
        tableView.register(R.nib.settingsTextFieldTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_TextField.identifier)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SettingsViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsRow = viewModel.row(at: indexPath)
        guard let settingsCell = tableView.dequeueReusableCell(withIdentifier: settingsRow.identifier, for: indexPath) as? SettingsTableViewCell else {
            fatalError("SettingsTableViewCell DOES NOT EXIST!!!")
        }

        settingsCell.setup(settingsRow: settingsRow, indexPath: indexPath)        

        return settingsCell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .clear

        return footer
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = R.reuseIdentifier.settingsTableViewCell_Label.identifier
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingsTableViewCell else {
            fatalError("HeaderCell does not exist!")
        }

        headerCell.setupHeaderCell(title: viewModel.headerTitle(in: section))
        return headerCell.contentView
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedRow = viewModel.row(at: indexPath)

        switch selectedRow {
        case .button,
             .control,             
             .textField: return
        case .datePicker(let title, let selectedDate):
            showDatePicker(title: title, selectedDate: selectedDate, indexPath: indexPath)
        case .stringPicker(let title, let pickerItems, let selectedIndex):
            showStringPicker(title: title, items: pickerItems, selectedIndex: selectedIndex, indexPath: indexPath)
        case .multipleStringPicker(let title, let rows, let initialSelection):
            showMultiplePicker(title: title, rows: rows, initialSelection: initialSelection, indexPath: indexPath)
        case .label(_, let value):
            triggerNotification(withName: value)
        }
    }
}

// MARK: - Notification

extension SettingsViewController {

    // FIXME: remove when remote notifications available
    func triggerNotification(withName name: String?) {
        guard let name = name, let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let handler = appDelegate.appCoordinator.remoteNotificationHandler
        let appCoordinator = appDelegate.appCoordinator
        let completion = { (error: Error?) in
            handler.isAuthorised({ (isAuthorised: Bool) in
                if isAuthorised {
                    if let error = error {
                        self.showNotificationErrorAlert(error)
                    }
                } else {
                    appCoordinator.showAlert(type: .notificationsNotAuthorized, handler: {
                        UIApplication.openAppSettings()
                    }, handlerDestructive: nil)
                }
            })
        }
        
        switch name {
        case "Morning Inter View":
            handler.triggerLocalNotification(withTitle: "Good Morning", subtitle: "Lets start the day with a quick interview.", body: "Its about your qualitiy of sleep and will take not longer then 2 minutes.", identifier: RemoteNotificationHandler.LocalNotifcationIdentifier.interviewIdentifier, completion: completion)
        case "Your 5 Weekly Choices":
            let calendar = Calendar.current
            var dateComponents = calendar.dateComponents([.year, .month, .weekOfYear, .weekday], from: Date())
            dateComponents.weekOfYear! += 1
            dateComponents.weekday! = 1
            let startDate = calendar.date(from: dateComponents)!
            dateComponents.weekOfYear! += 1
            let endDate = calendar.date(from: dateComponents)!
            let userInfo = [
                "startDate": startDate,
                "endDate": endDate
            ]
            handler.triggerLocalNotification(withTitle: "Let's get going!", subtitle: "Choose your 5 weekly choices", body: "Focusing on the things that really matter will help your productivity.", identifier: RemoteNotificationHandler.LocalNotifcationIdentifier.weeklyChoicesIdentifier, userInfo: userInfo, completion: completion)
        default:
            log("unknown notification recieved: \(name)")
            break
        }
    }
    
    func showNotificationErrorAlert(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
                        self.delegate?.updateViewModelAndReload(viewController: self)
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

            self.delegate?.updateViewModelAndReload(viewController: self)
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

            self.delegate?.updateViewModelAndReload(viewController: self)
        }, cancel: { (_) in
            return
        }, origin: view)
    }
}
