//
//  SettingsViewController.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 26/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var tableView: UITableView!
    private var settingsModel: SettingsModel
    var selectedSettings: SettingsModel.Setting?
    var interactor: SettingsInteractorInterface?

    // MARK: - Init

    init(configure: Configurator<SettingsViewController>, services: Services) {
        settingsModel = SettingsModel(services: services)
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedSettings = nil
        UIApplication.shared.setStatusBarStyle(.lightContent)
        navigationItem.title = R.string.localized.settingsTitle().uppercased()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        tableView.registerDequeueable(SettingsCell.self)
        setCustomBackButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
    }
}

// MARK: - SettingsViewControllerInterface

extension SettingsViewController: SettingsViewControllerInterface {

    func setup(_ settings: SettingsModel) {
        view.backgroundColor = .navy
        settingsModel = settings
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsModel.itemCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsCell = tableView.dequeueCell(for: indexPath)
        let model = settingsModel.settingItem(at: indexPath)
        cell.configure(title: model.title)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let settingsTapped = settingsModel.settingItem(at: indexPath)
        selectedSettings = settingsTapped
        interactor?.handleTap(setting: settingsTapped)
    }
}
