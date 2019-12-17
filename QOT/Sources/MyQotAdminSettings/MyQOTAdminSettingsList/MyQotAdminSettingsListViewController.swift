//
//  MyQotAdminSettingsListViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

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
            return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyQotProfileOptionsTableViewCell = tableView.dequeueCell(for: indexPath)
        switch indexPath.row {
        case 0:
            cell.configure(title: interactor.getTitleForEnvironmentSettings(),
                           subtitle: interactor.getSubtitleForEnvironmentSettings())
        case 1:
            cell.configure(title: interactor.getTitleForLocalNotifications(),
                           subtitle: nil)
        case 2:
            cell.configure(title: interactor.getTitleForDCQuestion(),
                           subtitle: interactor.getSubtitleForDCQuestion())
        default:
            cell.configure(title: nil, subtitle: nil)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            router.presentEnvironmentSettings()
        case 1:
            router.presentLocalNotificationsSettings()
        case 2:
            router.presentSixthQuestionPriority()
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
