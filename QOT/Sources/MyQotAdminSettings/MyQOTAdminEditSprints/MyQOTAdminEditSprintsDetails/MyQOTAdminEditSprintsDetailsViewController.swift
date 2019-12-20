//
//  MyQOTAdminEditSprintsDetailsViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 19/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQOTAdminEditSprintsDetailsViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?

    var interactor: MyQOTAdminEditSprintsDetailsInteractorInterface!
    private lazy var router: MyQOTAdminEditSprintsDetailsRouter! = MyQOTAdminEditSprintsDetailsRouter(viewController: self)

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ThemeView.level2.apply(UIApplication.shared.statusBarView ?? UIView())
    }

    @objc func doneAction() {
//        interactor.showSelectedBucketsInDailyBrief()
        router.dismiss()
    }
}

// MARK: - Private
private extension MyQOTAdminEditSprintsDetailsViewController {
    func setupTableView() {
        ThemeView.level2.apply(view)
        ThemeView.level2.apply(tableView)
        ThemeView.level2.apply(headerView)
        tableView.registerDequeueable(MyQOTAdminEditSprintsDetailsTableViewCell.self)
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

// MARK: - TableView delegates
extension MyQOTAdminEditSprintsDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.getDatasourceCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyQOTAdminEditSprintsDetailsTableViewCell = tableView.dequeueCell(for: indexPath)
        let datasourceObject = interactor.getDatasourceObject(at: indexPath.row)
        let subtitle: String = "\(datasourceObject.value)"
        cell.configure(title: datasourceObject.property.rawValue, subTitle: subtitle)
        return cell
    }
}

// MARK: - MyQOTAdminEditSprintsDetailsViewControllerInterface
extension MyQOTAdminEditSprintsDetailsViewController: MyQOTAdminEditSprintsDetailsViewControllerInterface {
    func setupView() {
        let rightButtons = [roundedBarButtonItem(title: interactor.getDoneButtonTitle(),
                                               buttonWidth: .Done,
                                               action: #selector(doneAction),
                                               backgroundColor: .carbon,
                                               borderColor: .accent40)]
        updateBottomNavigation([backNavigationItem()], rightButtons)
    }
}
