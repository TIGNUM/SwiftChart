//
//  SettingsViewController.swift
//  QOT
//
//  Created by karmic on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SettingsViewController                      : UIViewController {
    
    @IBOutlet fileprivate weak var navigationBarView    : UIView?
    @IBOutlet fileprivate weak var titleLabel           : UILabel?
    @IBOutlet fileprivate weak var searchButton         : UIButton?
    @IBOutlet fileprivate weak var closeButton          : UIButton?
    @IBOutlet fileprivate weak var tableView            : UITableView?
    
    weak var delegate                                   : SettingsViewControllerDelegate?
    let viewModel                                       : SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.setupView()
        self.setupNavigationBar()
    }
}

// MARK: - Layout

extension SettingsViewController {
    
    fileprivate func setupNavigationBar() {
        self.titleLabel?.text = R.string.localized.settingsTitle()
        self.navigationBarView?.backgroundColor = .darkGray
    }
    
    fileprivate func setupView() {
        self.view.backgroundColor = .darkGray
        self.tableView?.backgroundColor = .darkGray
        self.tableView?.register(UINib(nibName: R.nib.settingsTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Id.identifier)
    }
}

// MARK: - Actions

extension SettingsViewController {
    
    @IBAction private func didTapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapSearchButton() {
        print("didTapSearchButton")
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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
