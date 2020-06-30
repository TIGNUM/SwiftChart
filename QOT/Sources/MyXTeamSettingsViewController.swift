//
//  MyXTeamSettingsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 29.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class MyXTeamSettingsViewController: UIViewController {

    // MARK: - Properties
    var interactor: MyXTeamSettingsInteractorInterface?
    var router: MyXTeamSettingsRouterInterface?
    @IBOutlet private weak var headerView: UIView!
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var tableView: UITableView!
    private var settingsModel: MyXTeamSettingsModel!
    @IBOutlet private weak var headerHeightConstraint: NSLayoutConstraint!

    // MARK: - Init
    init(configure: Configurator<MyXTeamSettingsViewController>) {
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
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(color: .carbon)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//           if let siriShortcutsVC  = segue.destination as? MyQotSiriShortcutsViewController {
//               MyQotSiriShortcutsConfigurator.configure(viewController: siriShortcutsVC)
//           } else if let activityTrackerVC = segue.destination as? MyQotSensorsViewController {
//               MyQotSensorsConfigurator.configure(viewController: activityTrackerVC)
//           } else if let syncedCalendarVC = segue.destination as? SyncedCalendarsViewController {
//               SyncedCalendarsConfigurator.configure(viewController: syncedCalendarVC)
//           }
       }
}

// MARK: - Private
private extension MyXTeamSettingsViewController {

}

// MARK: - Actions
private extension MyXTeamSettingsViewController {

}

// MARK: - MyXTeamSettingsViewControllerInterface
extension MyXTeamSettingsViewController: MyXTeamSettingsViewControllerInterface {
    func setup(_ settings: MyXTeamSettingsModel) {
         ThemeView.level3.apply(view)
        settingsModel = settings
        baseHeaderView?.configure(title: interactor?.teamSettingsText, subtitle: nil)
        // Do any additional setup after loading the view.
    }
}
