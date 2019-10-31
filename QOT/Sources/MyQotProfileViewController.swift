//
//  MyQotViewController.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotProfileViewController: BaseViewController, ScreenZLevel2 {

    // MARK: - Properties

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    var baseHeaderview: QOTBaseHeaderView?

    var interactor: MyQotProfileInteractorInterface?
    weak var delegate: CoachCollectionViewControllerDelegate?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderview = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderview?.addTo(superview: headerView)
        interactor?.viewDidLoad()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ThemeView.level2.apply(UIApplication.shared.statusBarView ?? UIView())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let accountSettingsVC  = segue.destination as? MyQotAccountSettingsViewController {
            MyQotAccountSettingsConfigurator.configure(viewController: accountSettingsVC)
        } else if let appSettingsVC  = segue.destination as? MyQotAppSettingsViewController {
            MyQotAppSettingsConfigurator.configure(viewController: appSettingsVC)
        } else if let supportVC = segue.destination as? MyQotSupportViewController {
            MyQotSupportConfigurator.configure(viewController: supportVC)
        } else if let aboutTignum = segue.destination as? MyQotAboutUsViewController {
            MyQotAboutUsConfigurator.configure(viewController: aboutTignum)
        }
    }
}

// MARK: - Actions

private extension MyQotProfileViewController {
    func setupTableView() {
        ThemeView.level2.apply(view)
        ThemeView.level2.apply(tableView)
        ThemeView.level2.apply(headerView)
        tableView.registerDequeueable(MyQotProfileOptionsTableViewCell.self)
        tableView.registerDequeueable(MyQotProfileHeaderView.self)
        ThemeView.level2.apply(self.view)
        baseHeaderview?.configure(title: interactor?.myProfileText(), subtitle: nil)
        headerViewHeightConstraint.constant = baseHeaderview?.calculateHeight(for: headerView.frame.size.width) ?? 0

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView.headerView(with: .level2)
        tableView.reloadData()
    }
}

// MARK: - MyQotViewControllerInterface

extension MyQotProfileViewController: MyQotProfileViewControllerInterface {
    func updateView() {
        tableView.reloadData()
    }
}

// MARK: - TableView Delegate and Datasource

extension MyQotProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = interactor?.getMenuItems(), items.count > 0 else {
            return 5
        }
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyQotProfileOptionsTableViewCell = tableView.dequeueCell(for: indexPath)
        if let items = interactor?.getMenuItems(),
                indexPath.row < items.count {
            cell.configure(interactor?.getMenuItems()[indexPath.row])
        } else {
            cell.configure(nil)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        trackUserEvent(.OPEN, action: .TAP)
        interactor?.presentController(for: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 104
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: MyQotProfileHeaderView = tableView.dequeueHeaderFooter()
        let data = MyQotProfileModel.HeaderViewModel(user: interactor?.getProfile(),
                                                     memberSinceTitle: interactor?.memberSinceText())
        headerView.configure(data: data)
        return headerView
    }
}
