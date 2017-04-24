//
//  SettingsViewController.swift
//  QOT
//
//  Created by karmic on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet fileprivate weak var tableView: UITableView!
    
    // MARK: - Properties

    let viewModel: SettingsViewModel
    
    // MARK: - Init
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        
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

extension SettingsViewController {
    
    fileprivate func setupView() {
        view.backgroundColor = .darkGray
        tableView?.backgroundColor = .darkGray
        tableView?.register(UINib(nibName: R.nib.settingsTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Id.identifier)
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingsCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsTableViewCell_Id.identifier, for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        
        settingsCell.setup()
        
        return settingsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - TopTabBarItem

extension SettingsViewController: TopTabBarItem {

    var topTabBarItem: TopTabBarController.Item {
        return TopTabBarController.Item(controller: self, title: R.string.localized.settingsTitle())
    }
}
