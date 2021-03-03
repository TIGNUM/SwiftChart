//
//  SyncedCalendarsViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol SyncedCalendarsViewControllerDelegate: class {
    func didChangeCalendarSyncValue(enabled: Bool, identifier: String)
}

final class SyncedCalendarsViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var separator: UIView!
    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: SyncedCalendarsViewModel?
    var interactor: SyncedCalendarsInteractorInterface?

    private lazy var rightButtons: [UIBarButtonItem] = {
        let save = RoundedButton(title: interactor?.saveButtonTitle, target: self, action: #selector(didTapSave))
        ThemableButton.darkButton.apply(save, title: interactor?.saveButtonTitle)
        let skip = RoundedButton(title: interactor?.skipButtonTitle, target: self, action: #selector(didTapSkip))
        ThemableButton.darkButton.apply(skip, title: interactor?.skipButtonTitle)
        return [save.barButton, skip.barButton]
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        setupTableView()
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return (interactor?.isInitialCalendarSelection ?? false) ? nil : [backNavigationItem()]
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return (interactor?.isInitialCalendarSelection ?? false) ? rightButtons : nil
    }
}

// MARK: - SyncedCalendarsViewControllerInterface
extension SyncedCalendarsViewController: SyncedCalendarsViewControllerInterface {
    func setupView(_ viewModel: SyncedCalendarsViewModel?) {
        self.viewModel = viewModel
        ThemeView.level3.apply(view)
        baseHeaderView?.configure(title: viewModel?.viewTitle, subtitle: viewModel?.viewSubtitle)
        ThemeText.syncedCalendarTitle.apply(viewModel?.viewTitle, to: baseHeaderView?.titleLabel)
        ThemeText.syncedCalendarDescription.apply(viewModel?.viewSubtitle, to: baseHeaderView?.subtitleTextView)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? .zero
        ThemeView.syncedCalendarSeparator.apply(separator)
        tableView.reloadData()
    }

    func updateViewModel(_ viewModel: SyncedCalendarsViewModel?) {
        self.viewModel = viewModel
    }
}

// MARK: - Actions
extension SyncedCalendarsViewController {
    @objc func didTapSkip() {
        interactor?.didTapSkip()
    }

    @objc func didTapSave() {
        interactor?.didTapSave()
    }
}

// MARK: - Private
private extension SyncedCalendarsViewController {
    func setupTableView() {
        tableView.registerDequeueable(SyncedCalendarCell.self)
        tableView.registerDequeueable(TitleTableHeaderView.self)
        tableView.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: BottomNavigationContainer.height, right: .zero)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SyncedCalendarsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.keys.count ?? .zero
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = SyncedCalendarsViewModel.Section(rawValue: section) ?? .onDevice
        return viewModel?.sections[sectionItem]?.count ?? .zero
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel?.headerHeight ?? .zero
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == .zero {
            return viewModel?.footerHeight ?? .zero
        }
        return .zero
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == .zero {
            let title = AppTextService.get(.my_qot_my_profile_app_settings_synced_calendars_section_footer_title_calendars_you_own)
            let headerView: TitleTableHeaderView = tableView.dequeueHeaderFooter()
            headerView.configure(title: title, theme: .level3, themeText: .syncedCalendarTableHeader, showSkeleton: false)
            return headerView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionItem = SyncedCalendarsViewModel.Section(rawValue: section) ?? .onDevice
        let headerView: TitleTableHeaderView = tableView.dequeueHeaderFooter()
        headerView.configure(title: sectionItem.title, theme: .level3, themeText: .syncedCalendarTableHeader, showSkeleton: false)
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
                       isSubscribed: item?.isSubscribed,
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
