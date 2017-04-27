//
//  SettingsViewController.swift
//  QOT
//
//  Created by karmic on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func didValueChanged(at indexPath: IndexPath, enabled: Bool)
    func didTapPickerCell(at indexPath: IndexPath, selectedValue: String)
    func didTapButton(at indexPath: IndexPath)
}

final class SettingsViewController: UITableViewController {

    // MARK: - Properties

    let viewModel: SettingsViewModel
    let settingsType: SettingsViewModel.SettingsType
    
    // MARK: - Init
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        self.settingsType = viewModel.settingsType
        
        super.init(nibName: nil, bundle: nil)
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
        view.backgroundColor = .black
        tableView?.backgroundColor = .black
    }

    func registerCells() {
        tableView.register(R.nib.settingsLabelTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Label.identifier)
        tableView.register(R.nib.settingsButtonTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Button.identifier)
        tableView.register(R.nib.settingsControlTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Control.identifier)
        tableView.register(R.nib.settingsTextFieldTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_TextField.identifier)
        tableView.register(R.nib.settingsDatePickerTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_DatePicker.identifier)
        tableView.register(R.nib.settingsStringPickerTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_StringPickerView.identifier)
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
            return UITableViewCell()
        }

        settingsCell.setup(settingsRow: settingsRow, indexPath: indexPath)
        settingsCell.delegate = self

        return settingsCell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableView.headerView(forSection: section)?.textLabel?.textColor = .white
        return viewModel.headerTitle(in: section)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
