//
//  MyQotSyncedCalendarsViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyQotSyncedCalendarsViewControllerDelegate: class {
    func didChangeCalendarSyncValue(sender: UISwitch, calendarIdentifier: String)
}

final class MyQotSyncedCalendarsViewController: UIViewController {

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bottomNavigationView: BottomNavigationBarView!

    var interactor: MyQotSyncedCalendarsInteractorInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.viewModel.update()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // check if there is changes?
        if interactor?.viewModel.isChanged() == true {
            NotificationCenter.default.post(name: .EKEventStoreChanged, object: EKEventStore.shared)
            NotificationCenter.default.post(Notification(name: .startSyncCalendarRelatedData))
        }
    }

    func setupTableView() {
        tableView.registerDequeueable(MyQotSyncedCalendarCell.self)
        tableView.registerDequeueable(TitleTableHeaderView.self)
    }
}

extension MyQotSyncedCalendarsViewController: MyQotSyncedCalendarsViewControllerInterface {
    func setupView(with title: String) {
        view.backgroundColor = .carbon
        bottomNavigationView.delegate = self
        headerLabel.text = title
        setupTableView()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyQotSyncedCalendarsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCount: Int = 0
        if interactor?.viewModel.calendarCountOnThisDevice ?? 0 > 0 { sectionCount += 1 }
        if interactor?.viewModel.calendarCountOnOtherDevices ?? 0 > 0 { sectionCount += 1 }
        return sectionCount
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 68
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: TitleTableHeaderView = tableView.dequeueHeaderFooter()
        headerView.config = TitleTableHeaderView.Config(backgroundColor: .carbon)
        headerView.title = interactor?.viewModel.headerTitle(in: section) ?? ""
        return headerView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch CalendarLocation(rawValue: section) {
        case .onThisDevice? :
            return interactor?.viewModel.calendarCountOnThisDevice ?? 0
        default:
            return interactor?.viewModel.calendarCountOnOtherDevices ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = interactor?.viewModel.calendarName(at: indexPath)
        let calendarIdentifier = interactor?.viewModel.calendarIdentifier(at: indexPath)
        let calendarSource = interactor?.viewModel.calendarSource(at: indexPath)
        let syncStatus = interactor?.viewModel.calendarSyncStatus(at: indexPath)
        let settingsType: SettingsType

        switch CalendarLocation(rawValue: indexPath.section) {
        case .onThisDevice? :
            settingsType = .calendar
        default:
            settingsType = .calendarOnOtherDevices
        }

        let settingsRow = SettingsRow.control(title: title ?? "",
                                              isOn: syncStatus ?? false,
                                              settingsType: settingsType,
                                              key: calendarIdentifier,
                                              source: calendarSource)

        let settingsCell: MyQotSyncedCalendarCell = tableView.dequeueCell(for: indexPath)
        settingsCell.calendarSyncDelegate = self
        settingsCell.setup(settingsRow: settingsRow,
                           indexPath: indexPath,
                           calendarIdentifier: calendarIdentifier,
                           calendarSource: calendarSource,
                           isSyncFinished: interactor?.viewModel.isSyncFinished ?? false)

        return settingsCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return interactor?.viewModel.cellHeight ?? 0
    }
}

// MARK: - SettingsCalendarListViewControllerDelegate

extension MyQotSyncedCalendarsViewController: MyQotSyncedCalendarsViewControllerDelegate {

    func didChangeCalendarSyncValue(sender: UISwitch, calendarIdentifier: String) {
        interactor?.viewModel.updateCalendarSyncStatus(canSync: sender.isOn, calendarIdentifier: calendarIdentifier)
        trackUserEvent(sender.isOn ? .SELECT : .DESELECT, valueType: calendarIdentifier, action: .TAP)
        interactor?.viewModel.update()
    }
}

extension MyQotSyncedCalendarsViewController: BottomNavigationBarViewProtocol {
    func willNavigateBack() {
        trackUserEvent(.CLOSE, action: .TAP)
        navigationController?.popViewController(animated: true)
    }
}
