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

    var tableView = UITableView(frame: CGRect.zero, style: .grouped)
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
            self.viewModel.update()
            self.tableView.reloadData()
        }

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.update()
        navigationItem.title = R.string.localized.sidebarTitleCalendars().uppercased()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.register(R.nib.settingsControlTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Control.identifier)
        tableView.register(R.nib.settingsLabelTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Label.identifier)
    }
}

// MARK: - Private

private extension SettingsCalendarListViewController {

    func addEventStoreNotificationHandler() {
        notificationHandler.handler = { [unowned self] (notificationCenter) in
            self.viewModel.update()
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
        tableView.topAnchor == fadeContainerView.topAnchor + 100 // MARK: FIXME: constant??
        tableView.leftAnchor == fadeContainerView.leftAnchor + 20 // MARK: FIXME: constant??
        tableView.rightAnchor ==  fadeContainerView.rightAnchor
        tableView.bottomAnchor == fadeContainerView.bottomAnchor
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.allowsSelection = true
		tableView.isScrollEnabled = true
        tableView.rowHeight = UITableViewAutomaticDimension

		fadeContainerView.setFade(top: 80, bottom: 0)
		view.layoutIfNeeded()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingsCalendarListViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCount = Int(0)
        if viewModel.calendarCountOnThisDevice > 0 { sectionCount += 1 }
        if viewModel.calendarCountOnOtherDevices > 0 { sectionCount += 1 }
        return sectionCount
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = R.reuseIdentifier.settingsTableViewCell_Label.identifier
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingsTableViewCell else {
            fatalError("SettingsHeaderCell does not exist!")
        }

        headerCell.setupHeaderCell(title: viewModel.headerTitle(in: section))
        return headerCell.contentView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch CalendarLocation(rawValue: section)! {
        case .onThisDevice :
            return viewModel.calendarCountOnThisDevice
        default:
            return viewModel.calendarCountOnOtherDevices
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = viewModel.calendarName(at: indexPath)
        let calendarIdentifier = viewModel.calendarIdentifier(at: indexPath)
        let calendarSource = viewModel.calendarSource(at: indexPath)
        let syncStatus = viewModel.calendarSyncStatus(at: indexPath)
        let settingsType: SettingsType

        switch CalendarLocation(rawValue: indexPath.section)! {
        case .onThisDevice :
            settingsType = .calendar
        default:
            settingsType = .calendarOnOtherDevices
        }

        let settingsRow = SettingsRow.control(title: title,
                                              isOn: syncStatus,
                                              settingsType: settingsType,
                                              key: calendarIdentifier,
                                              source: calendarSource)

        guard let settingsCell = tableView.dequeueReusableCell(withIdentifier: settingsRow.identifier,
                                                               for: indexPath) as? SettingsTableViewCell else {
            fatalError("SettingsTableViewCell DOES NOT EXIST!!!")
        }

        settingsCell.calendarSyncDelegate = self
        settingsCell.setup(settingsRow: settingsRow,
                           indexPath: indexPath,
                           calendarIdentifier: calendarIdentifier,
                           calendarSource: calendarSource,
                           isSyncFinished: viewModel.isSyncFinished)

        return settingsCell
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellHeight
    }
}

// MARK: - SettingsCalendarListViewControllerDelegate

extension SettingsCalendarListViewController: SettingsCalendarListViewControllerDelegate {

    func didChangeCalendarSyncValue(sender: UISwitch, calendarIdentifier: String) {
        viewModel.updateCalendarSyncStatus(canSync: sender.isOn, calendarIdentifier: calendarIdentifier)
        NotificationCenter.default.post(name: .EKEventStoreChanged, object: EKEventStore.shared)
    }
}
