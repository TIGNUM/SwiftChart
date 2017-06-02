//
//  SettingsViewController.swift
//  QOT
//
//  Created by karmic on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

protocol SettingsViewControllerDelegate: class {
    func didValueChanged(at indexPath: IndexPath, enabled: Bool)
    func didTapPickerCell(at indexPath: IndexPath, selectedValue: String)
    func didTapButton(at indexPath: IndexPath)
}

final class SettingsViewController: UITableViewController {

    // MARK: - Properties

    fileprivate let viewModel: SettingsViewModel
    fileprivate let settingsType: SettingsViewModel.SettingsType
    weak var topTabBarScrollViewDelegate: TopTabBarScrollViewDelegate?
    
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
        settingsCell.delegate = self

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
        case .button(_, _),
             .control(_, _),
             .label(_, _),
             .textField(_, _, _): return
        case .datePicker(let title, let selectedDate): showDatePicker(title: title, selectedDate: selectedDate)
        case .stringPicker(let title, let pickerItems, let selectedIndex):  showStringPicker(title: title, items: pickerItems, selectedIndex: selectedIndex)
        }
    }
}

// MARK: - DatePicker

private extension SettingsViewController {

    func showDatePicker(title: String, selectedDate: Date) {
        let picker = createDatePicker(with: title, selectedDate: selectedDate)
        self.setupPickerButtons(picker: picker)
        picker.show()
    }

    private func createDatePicker(with title: String, selectedDate: Date) -> ActionSheetDatePicker {
        return ActionSheetDatePicker(title: title, datePickerMode: .date,
            selectedDate: selectedDate,
            doneBlock: { [unowned self] (picker: ActionSheetDatePicker?, _, _) in
                self.tableView.reloadData()
            }, cancel: { (picker: ActionSheetDatePicker?) in
                return
        }, origin: view)
    }

    private func setupPickerButtons(picker: ActionSheetDatePicker) {
        picker.setDoneButton(UIBarButtonItem(title: "Done", style: .done, target: self, action: nil))
        picker.setCancelButton(UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil))
    }
}

// MARK: - StringPicker

private extension SettingsViewController {

    func showStringPicker(title: String, items: [String], selectedIndex: Index) {
        let picker = createStringPicker(with: title, items: items, selectedIndex: selectedIndex)
        self.setupPickerButtons(picker: picker)
        picker.show()
    }

    private func createStringPicker(with title: String, items: [String], selectedIndex: Index) -> ActionSheetStringPicker {
        return ActionSheetStringPicker(title: title, rows: items, initialSelection: selectedIndex, doneBlock: { (picker, _, _) in
            self.tableView.reloadData()
        }, cancel: { (picker) in
            return
        }, origin: view)
    }

    private func setupPickerButtons(picker: ActionSheetStringPicker) {
        picker.setDoneButton(UIBarButtonItem(title: "Done", style: .done, target: self, action: nil))
        picker.setCancelButton(UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil))
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.didScrollUnderTopTabBar(delegate: topTabBarScrollViewDelegate)
    }
}

// MARK: - SettingsViewControllerDelegate

extension SettingsViewController: SettingsViewControllerDelegate {

    func didValueChanged(at indexPath: IndexPath, enabled: Bool) {
        // Update ViewModel with changes.
    }

    func didTapPickerCell(at indexPath: IndexPath, selectedValue: String) {
        // Update view with nice animation and show/hide picker view.
    }

    func didTapButton(at indexPath: IndexPath) {
        // Navigate to selected view, like tutorial.
    }
}
