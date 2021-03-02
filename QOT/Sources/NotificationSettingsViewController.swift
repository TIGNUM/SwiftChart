//
//  NotificationSettingsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 03.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class NotificationSettingsViewController: BaseWithTableViewController, ScreenZLevel3 {

    // MARK: - Properties

    var interactor: NotificationSettingsInteractorInterface!
    private lazy var router: NotificationSettingsRouterInterface = NotificationSettingsRouter(viewController: self)
    @IBOutlet private weak var headerView: UIView!
    private var baseHeaderView: QOTBaseHeaderView?
    private var notificationModel = NotificationSettingsModel()

    // MARK: - Init
    init(configure: Configurator<NotificationSettingsViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        ThemeView.level3.apply(tableView)
        tableView.registerDequeueable(TitleSubtitleTableViewCell.self)
        tableView.registerDequeueable(TitleTableHeaderView.self)
        tableView.registerDequeueable(NotificationSettingCell.self)
        interactor.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(color: .black)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dailyRemindersVC = segue.destination as? DailyRemindersViewController {
            DailyRemindersConfigurator.make(viewController: dailyRemindersVC)
        }
    }
}

// MARK: - Private
private extension NotificationSettingsViewController {

}

// MARK: - Actions
private extension NotificationSettingsViewController {

}

// MARK: - NotificationSettingsViewControllerInterface
extension NotificationSettingsViewController: NotificationSettingsViewControllerInterface {
    func setup() {
        ThemeView.level3.apply(view)
        baseHeaderView?.configure(title: interactor?.notificationsTitle, subtitle: interactor?.notificationsSubtitle)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension NotificationSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationModel.notificationSettingsCount
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = NotificationSettingsModel.Setting.allSettings.at(index: indexPath.row)
        switch indexPath.row {
        case 0:
            let cell: TitleSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: notificationModel.title(for: item ?? .sprints),
                           subtitle: notificationModel.subtitle(for: item ?? .sprints))
            return cell
        default:
            let item = NotificationSettingsModel.Setting.allSettings.at(index: indexPath.row)
            let cell: NotificationSettingCell = tableView.dequeueCell(for: indexPath)
//            cell.calendarSyncDelegate = self
            cell.configure(title: notificationModel.title(for: item ?? .sprints),
                           subtitle: notificationModel.subtitle(for: item ?? .sprints),
                           isActive: notificationModel.isActive(for: item ?? .sprints))
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let settingTapped = notificationModel.settingItem(at: indexPath)
        interactor?.handleTap(setting: settingTapped)
    }
}
