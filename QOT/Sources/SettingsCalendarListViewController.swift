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

    private var tableView = UITableView(frame: .zero, style: .grouped)
    private var noPermissionLabel: UILabel = UILabel()
    private var openSettingButton: UIButton = UIButton()
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
        viewModel.syncStateObserver.onUpdate { [weak self] _ in
            self?.update()
        }

        tableView.delegate = self
        tableView.dataSource = self
        self.update()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.update()
        navigationItem.title = R.string.localized.sidebarTitleCalendars().uppercased()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // check if there is changes?
        if self.viewModel.isChanged() == true {
            NotificationCenter.default.post(name: .EKEventStoreChanged, object: EKEventStore.shared)
            NotificationCenter.default.post(Notification(name: .startSyncCalendarRelatedData))
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.register(UINib(resource: R.nib.settingsControlTableViewCell),
                           forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Control.identifier)
        tableView.register(UINib(resource: R.nib.settingsLabelTableViewCell),
                           forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Label.identifier)
    }
}

// MARK: - Private

private extension SettingsCalendarListViewController {

    func update() {
        DispatchQueue.main.async {
            self.viewModel.update()
            self.tableView.reloadData()
            let authStatus = EKEventStore.authorizationStatus(for: .event)
            switch authStatus {
            case .denied:
                self.noPermissionLabel.isVisible = true
                self.openSettingButton.isVisible = true
            case .notDetermined:
                self.askCalendarPermission()
                self.noPermissionLabel.isVisible = false
                self.openSettingButton.isVisible = false
            default:
                self.noPermissionLabel.isVisible = false
                self.openSettingButton.isVisible = false
            }
        }
    }

    func addEventStoreNotificationHandler() {
        notificationHandler.handler = { [weak self] (notificationCenter) in
            self?.update()
        }
    }

    func setupView() {
        setCustomBackButton()
        view.backgroundColor = .navy
        view.addBlackNavigationView()
		let fadeContainerView = FadeContainerView()
		view.addSubview(fadeContainerView)
		fadeContainerView.edgeAnchors == view.edgeAnchors
        fadeContainerView.addSubview(tableView)
        fadeContainerView.backgroundColor = .navy
        tableView.topAnchor == fadeContainerView.topAnchor + Layout.padding_16
        tableView.leftAnchor == fadeContainerView.leftAnchor + Layout.padding_16
        tableView.rightAnchor ==  fadeContainerView.rightAnchor
        tableView.bottomAnchor == fadeContainerView.bottomAnchor
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.allowsSelection = true
		tableView.isScrollEnabled = true
        tableView.rowHeight = UITableViewAutomaticDimension
		fadeContainerView.setFade(top: 80, bottom: 0)
        setupOpenSettingForCalendar(fadeContainerView: fadeContainerView)
		view.layoutIfNeeded()
    }

    func setupOpenSettingForCalendar(fadeContainerView: UIView) {
        noPermissionLabel = UILabel()
        ThemeText.calendarNoAccess.apply(R.string.localized.alertMessageCalendarNoAccess(), to: noPermissionLabel)
        noPermissionLabel.numberOfLines = 0
        fadeContainerView.addSubview(noPermissionLabel)
        noPermissionLabel.translatesAutoresizingMaskIntoConstraints = false
        let labelCenterX: NSLayoutConstraint = NSLayoutConstraint(item: noPermissionLabel, attribute: .centerX,
                                                                  relatedBy: .equal, toItem: fadeContainerView,
                                                                  attribute: .centerX,
                                                                  multiplier: 1,
                                                                  constant: 0)
        let labelWidth: NSLayoutConstraint = NSLayoutConstraint(item: noPermissionLabel, attribute: .width,
                                                                relatedBy: .equal, toItem: fadeContainerView,
                                                                attribute: .width,
                                                                multiplier: 0.75,
                                                                constant: 0)
        let labelPosY: NSLayoutConstraint = NSLayoutConstraint(item: noPermissionLabel, attribute: .bottom,
                                                               relatedBy: .equal, toItem: fadeContainerView,
                                                               attribute: .centerY,
                                                               multiplier: 1,
                                                               constant: 0)
        fadeContainerView.addConstraint(labelCenterX)
        fadeContainerView.addConstraint(labelWidth)
        fadeContainerView.addConstraint(labelPosY)
        openSettingButton = UIButton()
        fadeContainerView.addSubview(openSettingButton)
        openSettingButton.setTitle(R.string.localized.alertButtonTitleOpenSettings(), for: UIControlState.normal)
        openSettingButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        openSettingButton.addTarget(self, action: #selector(didTapPermissionButton), for: UIControlEvents.touchUpInside)
        openSettingButton.corner(radius: Layout.CornerRadius.eight.rawValue)
        openSettingButton.backgroundColor = .azure
        openSettingButton.showsTouchWhenHighlighted = true
        openSettingButton.translatesAutoresizingMaskIntoConstraints = false
        let buttonCenterX: NSLayoutConstraint = NSLayoutConstraint(item: openSettingButton, attribute: .centerX,
                                                                   relatedBy: .equal, toItem: noPermissionLabel,
                                                                   attribute: .centerX,
                                                                   multiplier: 1,
                                                                   constant: 0)
        let buttonWidth: NSLayoutConstraint = NSLayoutConstraint(item: openSettingButton, attribute: .width,
                                                                 relatedBy: .equal, toItem: fadeContainerView,
                                                                 attribute: .width,
                                                                 multiplier: 0.5,
                                                                 constant: 0)
        let buttonPosY: NSLayoutConstraint = NSLayoutConstraint(item: openSettingButton, attribute: .top,
                                                                relatedBy: .equal, toItem: noPermissionLabel,
                                                                attribute: .bottom,
                                                                multiplier: 1,
                                                                constant: 20)
        fadeContainerView.addConstraint(buttonCenterX)
        fadeContainerView.addConstraint(buttonWidth)
        fadeContainerView.addConstraint(buttonPosY)
        noPermissionLabel.isVisible = false
        openSettingButton.isVisible = false
    }

    @objc func didTapPermissionButton() {
        UIApplication.openAppSettings()
    }

    func askCalendarPermission() {
        let calendarPermission = CalendarPermission()
        calendarPermission.askPermission { [weak self] result in
            self?.update()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingsCalendarListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCount: Int = 0
        if viewModel.calendarCountOnThisDevice > 0 { sectionCount += 1 }
        if viewModel.calendarCountOnOtherDevices > 0 { sectionCount += 1 }
        return sectionCount
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = R.reuseIdentifier.settingsTableViewCell_Label.identifier
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingsTableViewCell else {
            fatalError("SettingsHeaderCell does not exist!")
        }
        headerCell.setupHeaderCell(title: CalendarLocation(rawValue: section)?.headerTitle ?? "")
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
        let settingsType = CalendarLocation(rawValue: indexPath.section)?.settingsType ?? .calendar
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellHeight
    }
}

// MARK: - SettingsCalendarListViewControllerDelegate

extension SettingsCalendarListViewController: SettingsCalendarListViewControllerDelegate {

    func didChangeCalendarSyncValue(sender: UISwitch, calendarIdentifier: String) {
        viewModel.updateCalendarSyncStatus(canSync: sender.isOn, calendarIdentifier: calendarIdentifier)
        viewModel.update()
    }
}
