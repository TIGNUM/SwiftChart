//
//  MyQotAdminLocalNotificationsViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 13/12/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class MyQotAdminLocalNotificationsViewController: BaseViewController {
    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?

    var interactor: MyQotAdminLocalNotificationsInteractorInterface!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        MyQotAdminLocalNotificationsConfigurator.configure(viewController: self)
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
private extension MyQotAdminLocalNotificationsViewController {
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

extension MyQotAdminLocalNotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.getDatasourceCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyQotProfileOptionsTableViewCell = tableView.dequeueCell(for: indexPath)

        cell.configure(title: interactor.getTitle(at:indexPath.row),
                       subtitle: interactor.getSubtitle(at:indexPath.row))

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        interactor.scheduleNotification(title: interactor.getNotificationTitle(),
                                        body: interactor.getTitle(at:indexPath.row),
                                        link: interactor.getSubtitle(at:indexPath.row)) { [weak self] in
                                DispatchQueue.main.async {
                                    self?.navigationController?.popViewController(animated: true)
                                }
        }
    }
}

// MARK: - MyQotAdminLocalNotificationsViewControllerInterface
extension MyQotAdminLocalNotificationsViewController: MyQotAdminLocalNotificationsViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
