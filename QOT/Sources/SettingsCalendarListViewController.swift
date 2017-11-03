//
//  SettingsCalendarListViewController.swift
//  QOT
//
//  Created by karmic on 25.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import EventKit

protocol SettingsCalendarListViewControllerDelegate: class {

    func didChangeCalendarSyncValue(sender: UISwitch, calendarIdentifier: String)
}

final class SettingsCalendarListViewController: UITableViewController {

    // MARK: - Properties

    private let viewModel: SettingsCalendarListViewModel
    private let notificationHandler: NotificationHandler

    // MARK: - Init

    init(viewModel: SettingsCalendarListViewModel) {
        self.viewModel = viewModel
        self.notificationHandler = NotificationHandler(name: .EKEventStoreChanged, object: EKEventStore.shared)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addEventStoreNotificationHandler()
        setupView()
    }
}

// MARK: - Private

private extension SettingsCalendarListViewController {

    func addEventStoreNotificationHandler() {
        notificationHandler.handler = { [unowned self] (notificationCenter) in
            self.tableView.reloadData()
        }
    }

    func setupView() {
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.allowsSelection = true
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(R.nib.settingsControlTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Control.identifier)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingsCalendarListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.calendarCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = viewModel.calendarName(at: indexPath)
        let calendarIdentifier = viewModel.calendarIdentifier(at: indexPath)
        let syncStatus = viewModel.calendarSyncStatus(at: indexPath)
        let settingsRow = SettingsRow.control(title: title, isOn: syncStatus, settingsType: .calendar, key: calendarIdentifier)

        guard let settingsCell = tableView.dequeueReusableCell(withIdentifier: settingsRow.identifier, for: indexPath) as? SettingsTableViewCell else {
            fatalError("SettingsTableViewCell DOES NOT EXIST!!!")
        }

        settingsCell.calendarSyncDelegate = self
        settingsCell.setup(settingsRow: settingsRow, indexPath: indexPath, calendarIdentifier: calendarIdentifier)

        return settingsCell
    }
}

// MARK: - SettingsCalendarListViewControllerDelegate

extension SettingsCalendarListViewController: SettingsCalendarListViewControllerDelegate {

    func didChangeCalendarSyncValue(sender: UISwitch, calendarIdentifier: String) {
        viewModel.updateCalendarSyncStatus(canSync: sender.isOn, calendarIdentifier: calendarIdentifier)
        NotificationCenter.default.post(name: .EKEventStoreChanged, object: EKEventStore.shared)
    }
}
