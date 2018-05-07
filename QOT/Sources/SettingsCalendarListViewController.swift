//
//  SettingsCalendarListViewController.swift
//  QOT
//
//  Created by karmic on 25.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import EventKit
import Anchorage

protocol SettingsCalendarListViewControllerDelegate: class {

    func didChangeCalendarSyncValue(sender: UISwitch, calendarIdentifier: String)
}

final class SettingsCalendarListViewController: UIViewController {

    // MARK: - Properties

    var tableView = UITableView()
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
        viewModel.syncStateObserver.onUpdate { [unowned self] _ in
            self.tableView.reloadData()
        }

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = R.string.localized.sidebarTitleCalendars().uppercased()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.register(R.nib.settingsControlTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Control.identifier)
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
		let fadeContainerView = FadeContainerView()
		view.addSubview(fadeContainerView)
		fadeContainerView.edgeAnchors == view.edgeAnchors
		
        let backgroundImageView = UIImageView(image: R.image._1_1Learn())
        fadeContainerView.addSubview(backgroundImageView)
        backgroundImageView.edgeAnchors == fadeContainerView.edgeAnchors

        fadeContainerView.addSubview(tableView)
        tableView.topAnchor == fadeContainerView.topAnchor + 100
        tableView.leftAnchor == fadeContainerView.leftAnchor + 30
        tableView.rightAnchor ==  fadeContainerView.rightAnchor
        tableView.bottomAnchor == fadeContainerView.bottomAnchor
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.allowsSelection = true
		tableView.isScrollEnabled = false
        tableView.rowHeight = UITableViewAutomaticDimension
		
		fadeContainerView.setFade(top: 80, bottom: 0)
		view.layoutIfNeeded()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingsCalendarListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.calendarCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = viewModel.calendarName(at: indexPath)
        let calendarIdentifier = viewModel.calendarIdentifier(at: indexPath)
        let syncStatus = viewModel.calendarSyncStatus(at: indexPath)
        let settingsRow = SettingsRow.control(title: title,
                                              isOn: syncStatus,
                                              settingsType: .calendar,
                                              key: calendarIdentifier)

        guard let settingsCell = tableView.dequeueReusableCell(withIdentifier: settingsRow.identifier,
                                                               for: indexPath) as? SettingsTableViewCell else {
            fatalError("SettingsTableViewCell DOES NOT EXIST!!!")
        }

        settingsCell.calendarSyncDelegate = self
        settingsCell.setup(settingsRow: settingsRow,
                           indexPath: indexPath,
                           calendarIdentifier: calendarIdentifier,
                           isSyncFinished: viewModel.isSyncFinished)

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
