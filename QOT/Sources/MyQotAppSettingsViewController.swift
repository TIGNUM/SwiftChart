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

    private var settingsModel: MyQotAppSettingsModel!
    private var selectedSettings: MyQotAppSettingsModel.Setting?
    var interactor: MyQotAppSettingsInteractorInterface?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        ThemeView.level3.apply(tableView)
        tableView.registerDequeueable(TitleSubtitleTableViewCell.self)
        tableView.registerDequeueable(TitleTableHeaderView.self)
        tableView.registerDequeueable(AppSettingsFooterView.self)
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
        } else if let syncedCalendarVC = segue.destination as? SyncedCalendarsViewController {
            SyncedCalendarsConfigurator.configure(viewController: syncedCalendarVC)
        }
    }
}

// MARK: - MyQotAppSettingsViewControllerInterface

extension MyQotAppSettingsViewController: MyQotAppSettingsViewControllerInterface {
    func setup(_ settings: MyQotAppSettingsModel) {
        ThemeView.level3.apply(view)
        settingsModel = settings
        interactor?.appSettingsText({[weak self] (text) in
            ThemeText.myQOTSectionHeader.apply(text, to: self?.appSettingsHeaderLabel)
        })
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

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return settingsModel.heightForFooter(in: section)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return settingsModel.heightForHeader(in: section)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let footerView: AppSettingsFooterView = tableView.dequeueHeaderFooter()
            footerView.versionLabel.text = Bundle.main.versionAndBuildNumber
            return footerView
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: TitleTableHeaderView = tableView.dequeueHeaderFooter()
        settingsModel.headerTitleForItem(at: section, completion: {(text) in
            headerView.configure(title: text, theme: .level3)
        })
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TitleSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
        settingsModel.titleForItem(at: indexPath) { (text) in
            cell.configure(title: text, themeCell: .level3)
        }
        settingsModel.subtitleForItem(at: indexPath) { (text) in
            cell.configure(subTitle: text)
        }
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
