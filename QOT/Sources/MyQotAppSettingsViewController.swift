//
//  MyQotAppSettingsViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAppSettingsViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var appSettingsHeaderLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bottomNavigationView: BottomNavigationBarView!

    private var settingsModel: MyQotAppSettingsModel!
    private var selectedSettings: MyQotAppSettingsModel.Setting?
    var interactor: MyQotAppSettingsInteractorInterface?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        tableView.registerDequeueable(TitleSubtitleTableViewCell.self)
        tableView.registerDequeueable(TitleTableHeaderView.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = .carbon
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let siriShortcutsVC  = segue.destination as? MyQotSiriShortcutsViewController {
            MyQotSiriShortcutsConfigurator.configure(viewController: siriShortcutsVC)
        } else if let activityTrackerVC = segue.destination as? MyQotSensorsViewController {
            MyQotSensorsConfigurator.configure(viewController: activityTrackerVC)
        } else if let syncedCalendarVC = segue.destination as? MyQotSyncedCalendarsViewController {
            MyQotSyncedCalendarsConfigurator.configure(viewController: syncedCalendarVC)
        }
    }
}

// MARK: - MyQotAppSettingsViewControllerInterface

extension MyQotAppSettingsViewController: MyQotAppSettingsViewControllerInterface {
    func setup(_ settings: MyQotAppSettingsModel) {
        view.backgroundColor = .carbon
        bottomNavigationView.delegate = self
        settingsModel = settings
        appSettingsHeaderLabel.text = interactor?.appSettingsText
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyQotAppSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsModel.sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = MyQotAppSettingsModel.SettingsType.allCases[section]
        switch type {
        case MyQotAppSettingsModel.SettingsType.general:
            return settingsModel.generalSettingsCount
        case MyQotAppSettingsModel.SettingsType.custom:
            return settingsModel.customSettingsCount
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: TitleTableHeaderView = tableView.dequeueHeaderFooter()
        headerView.config = TitleTableHeaderView.Config()
        let title = settingsModel.headerTitleForItem(at: section)
        headerView.title = title
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TitleSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.config = TitleSubtitleTableViewCell.Config()
        let title = settingsModel.titleForItem(at: indexPath)
        let subtitle = settingsModel.subtitleForItem(at: indexPath)
        cell.configure(title: title, subTitle: subtitle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let settingsTapped = settingsModel.settingItem(at: indexPath)
        let key = settingsModel.trackingKeyForItem(at: indexPath)
        trackUserEvent(.OPEN, valueType: key, action: .TAP)
        selectedSettings = settingsTapped
        interactor?.handleTap(setting: settingsTapped)
    }
}

extension MyQotAppSettingsViewController: BottomNavigationBarViewProtocol {
    func willNavigateBack() {
        trackUserEvent(.CLOSE, action: .TAP)
        navigationController?.popViewController(animated: true)
    }
}
