//
//  MyQotAdminEnvironmentSettingsViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import UIKit
import qot_dal

final class MyQotAdminEnvironmentSettingsViewController: BaseViewController {
    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ThemeView.level2.apply(UIApplication.shared.statusBarView ?? UIView())
        tableView.reloadData()
    }
}
    // MARK: - Private
private extension MyQotAdminEnvironmentSettingsViewController {
    func setupTableView() {
        ThemeView.level2.apply(view)
        ThemeView.level2.apply(tableView)
        ThemeView.level2.apply(headerView)
        tableView.registerDequeueable(MyQotProfileOptionsTableViewCell.self)
        ThemeView.level2.apply(self.view)
        baseHeaderView?.configure(title: "ENVIRONMENT SETTINGS", subtitle: nil)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? 0

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView.headerView(with: .level2)
        tableView.reloadData()
    }
}
    // MARK: - TableView Delegate and Datasource

extension MyQotAdminEnvironmentSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyQotProfileOptionsTableViewCell = tableView.dequeueCell(for: indexPath)
        let isStaging = NetworkRequestManager.main.getCurrentEnvironment() == .development
        let checkMark = R.image.registration_checkmark()
        switch indexPath.row {
        case 0:
            cell.configure(title: "STAGING", subtitle: nil)
            cell.customAccessoryImageView.image = isStaging ? checkMark : nil
        case 1:
            cell.configure(title: "PRODUCTION", subtitle: nil)
            cell.customAccessoryImageView.image = isStaging ? nil : checkMark
        default:
            cell.configure(title: nil, subtitle: nil)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        NetworkRequestManager.main.switchTo(environmentType: indexPath.row == 0 ? .development : .production)
        self.navigationController?.popViewController(animated: true)
        DatabaseManager.main.deleteUserRelatedData()
        NotificationCenter.default.post(name: .requestSynchronization, object: nil)
    }
}
