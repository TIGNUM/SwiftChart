//
//  MyQotAdminEnvironmentSettingsViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class MyQotAdminEnvironmentSettingsViewController: BaseViewController {
    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?

    var interactor: MyQotAdminEnvironmentSettingsInteractorInterface!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        MyQotAdminEnvironmentSettingsConfigurator.configure(viewController: self)
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
        trackPage()
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

extension MyQotAdminEnvironmentSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.getDatasourceCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyQotProfileOptionsTableViewCell = tableView.dequeueCell(for: indexPath)
        let checkMark = R.image.registration_checkmark()

        cell.configure(title: interactor.getTitle(at: indexPath.row),
                    subtitle: nil)
        cell.customAccessoryImageView.image = interactor.getIsSelected(for: indexPath.row) ? checkMark : nil

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        interactor.changeSelection(for: indexPath.row)
        self.navigationController?.popViewController(animated: true)

    }
}

// MARK: - MyQotAdminEnvironmentSettingsViewControllerInterface
extension MyQotAdminEnvironmentSettingsViewController: MyQotAdminEnvironmentSettingsViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
