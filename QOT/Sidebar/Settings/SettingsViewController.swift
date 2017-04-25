//
//  SettingsViewController.swift
//  QOT
//
//  Created by karmic on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

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
                
        setupView()
    }
}

// MARK: - Layout

private extension SettingsViewController {
    
    func setupView() {
        view.backgroundColor = .black
        tableView?.backgroundColor = .black
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

        settingsCell.setup(settingsRow: settingsRow)

        return settingsCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - TopTabBarItem

extension SettingsViewController: TopTabBarItem {

    var topTabBarItem: TopTabBarController.Item {
        switch settingsType {
        case .general: return TopTabBarController.Item(controller: self, title: R.string.localized.settingsTitleGeneral())
        case .notifications: return TopTabBarController.Item(controller: self, title: R.string.localized.settingsTitleNotifications())
        case .security: return TopTabBarController.Item(controller: self, title: R.string.localized.settingsTitleSecurity())
        }
    }
}
