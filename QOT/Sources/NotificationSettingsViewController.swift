//
//  NotificationSettingsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 03.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class NotificationSettingsViewController: BaseViewController, ScreenZLevel3  {

    // MARK: - Properties

    var interactor: NotificationSettingsInteractorInterface!
    private lazy var router: NotificationSettingsRouterInterface = NotificationSettingsRouter(viewController: self)
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var tableView: UITableView!
    private var notificationModel = NotificationSettingsModel()

//    private var selectedSettings: MyQotAppSettingsModel.Setting?

    // MARK: - Init
    init(configure: Configurator<NotificationSettingsViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        ThemeView.level3.apply(tableView)
//        tableView.registerDequeueable(TitleSubtitleTableViewCell.self)
//        tableView.registerDequeueable(TitleTableHeaderView.self)
        interactor.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(color: .black)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        TRACK
        trackPage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let siriShortcutsVC  = segue.destination as? MyQotSiriShortcutsViewController {
//            MyQotSiriShortcutsConfigurator.configure(viewController: siriShortcutsVC)
//        } else if let activityTrackerVC = segue.destination as? MyQotSensorsViewController {
//            MyQotSensorsConfigurator.configure(viewController: activityTrackerVC)
//        } else if let syncedCalendarVC = segue.destination as? SyncedCalendarsViewController {
//            SyncedCalendarsConfigurator.configure(viewController: syncedCalendarVC)
//        }
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
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? 0
    }
}
