//
//  SyncedCalendarsViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol SyncedCalendarsViewControllerDelegate: class {
    func didChangeCalendarSyncValue(enabled: Bool, identifier: String)
}

final class SyncedCalendarsViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: SyncedCalendarsViewModel?
    var interactor: SyncedCalendarsInteractorInterface?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }
}

// MARK: - SyncedCalendarsViewControllerInterface
extension SyncedCalendarsViewController: SyncedCalendarsViewControllerInterface {
    func setupView(_ viewModel: SyncedCalendarsViewModel?) {
        self.viewModel = viewModel
        headerLabel.text = viewModel?.viewTitle
        tableView.reloadDataWithAnimation()
    }

    func updateViewModel(_ viewModel: SyncedCalendarsViewModel?) {
        self.viewModel = viewModel
    }
}

// MARK: - Private
private extension SyncedCalendarsViewController {
    func setupTableView() {
        tableView.registerDequeueable(SyncedCalendarCell.self)
        tableView.registerDequeueable(TitleTableHeaderView.self)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SyncedCalendarsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.keys.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = SyncedCalendarsViewModel.Section(rawValue: section) ?? .onDevice
        return viewModel?.sections[sectionItem]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel?.headerHeight ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionItem = SyncedCalendarsViewModel.Section(rawValue: section) ?? .onDevice
        let headerView: TitleTableHeaderView = tableView.dequeueHeaderFooter()
        headerView.configure(title: sectionItem.title, theme: .level3)
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionItem = SyncedCalendarsViewModel.Section(rawValue: indexPath.section) ?? .onDevice
        let item = viewModel?.sections[sectionItem]?.at(index: indexPath.row)
        let cell: SyncedCalendarCell = tableView.dequeueCell(for: indexPath)
        cell.calendarSyncDelegate = self
        cell.configure(title: item?.title,
                       source: item?.source,
                       syncEabled: item?.syncEnabled,
                       identifier: item?.identifier,
                       switchIsHidden: item?.switchIsHidden)
        return cell
    }
}

// MARK: - SettingsCalendarListViewControllerDelegate
extension SyncedCalendarsViewController: SyncedCalendarsViewControllerDelegate {
    func didChangeCalendarSyncValue(enabled: Bool, identifier: String) {
        interactor?.updateSyncStatus(enabled: enabled, identifier: identifier)
        trackUserEvent(enabled ? .SELECT : .DESELECT, valueType: identifier, action: .TAP)
    }
}
