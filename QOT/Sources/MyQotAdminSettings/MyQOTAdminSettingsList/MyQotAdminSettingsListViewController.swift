//
//  MyQotAdminSettingsListViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

enum adminSettingsItem: Int, CaseIterable {
    case environmentSettings = 0
    case localNotifications
    case dailyCheckinSixthQuestion
    case chooseDailyBriefBuckets
}

final class MyQotAdminSettingsListViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?

    var interactor: MyQotAdminSettingsListInteractorInterface!
    private lazy var router = MyQotAdminSettingsListRouter(viewController: self)

    // MARK: - Init
    init(configure: Configurator<MyQotAdminSettingsListViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        interactor.viewDidLoad()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ThemeView.level2.apply(UIApplication.shared.statusBarView ?? UIView())
        MyQotAdminDCSixthQuestionSettingsInteractor.getSixthQuestionPriority { [weak self] (setting) in
            self?.interactor.setCurrentSixthQuestionSetting(setting: setting)
            self?.tableView.reloadData()
        }
    }
}

// MARK: - Private
private extension MyQotAdminSettingsListViewController {
    func setupTableView() {
        ThemeView.level2.apply(view)
        ThemeView.level2.apply(tableView)
        ThemeView.level2.apply(headerView)
        tableView.registerDequeueable(MyQotProfileOptionsTableViewCell.self)
        ThemeView.level2.apply(self.view)
        baseHeaderView?.configure(title: interactor.getHeaderTitle(),
                                  subtitle: nil)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? 0

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView.headerView(with: .level2)
        tableView.reloadData()
    }
}

// MARK: - TableView Delegate and Datasource

extension MyQotAdminSettingsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adminSettingsItem.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyQotProfileOptionsTableViewCell = tableView.dequeueCell(for: indexPath)
        switch indexPath.row {
        case adminSettingsItem.environmentSettings.rawValue:
            cell.configure(title: interactor.getTitleForEnvironmentSettings(),
                           subtitle: interactor.getSubtitleForEnvironmentSettings())
        case adminSettingsItem.localNotifications.rawValue:
            cell.configure(title: interactor.getTitleForLocalNotifications(),
                           subtitle: nil)
        case adminSettingsItem.dailyCheckinSixthQuestion.rawValue:
            cell.configure(title: interactor.getTitleForDCQuestion(),
                           subtitle: interactor.getSubtitleForDCQuestion())
        case adminSettingsItem.chooseDailyBriefBuckets.rawValue:
            cell.configure(title: interactor.getTitleForChooseBuckets(),
                           subtitle: nil)
        default:
            cell.configure(title: nil, subtitle: nil)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case adminSettingsItem.environmentSettings.rawValue:
            router.presentEnvironmentSettings()
        case adminSettingsItem.localNotifications.rawValue:
            router.presentLocalNotificationsSettings()
        case adminSettingsItem.dailyCheckinSixthQuestion.rawValue:
            router.presentSixthQuestionPriority()
        case adminSettingsItem.chooseDailyBriefBuckets.rawValue:
            router.presentChooseDailyBriefBuckets()
        default:
            break
        }
    }
}

// MARK: - MyQotAdminSettingsListViewControllerInterface
extension MyQotAdminSettingsListViewController: MyQotAdminSettingsListViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
