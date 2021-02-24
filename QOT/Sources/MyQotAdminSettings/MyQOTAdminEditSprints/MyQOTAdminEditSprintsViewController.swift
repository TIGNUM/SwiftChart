//
//  MyQOTAdminEditSprintsViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 19/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQOTAdminEditSprintsViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?

    var interactor: MyQOTAdminEditSprintsInteractorInterface!
    private lazy var router: MyQOTAdminEditSprintsRouter! = MyQOTAdminEditSprintsRouter(viewController: self)

    // MARK: - Init
    init(configure: Configurator<MyQOTAdminEditSprintsViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        MyQOTAdminEditSprintsConfigurator.configure(viewController: self)
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
        setupView()
        interactor.getSprints(completion: { [weak self] in
            self?.tableView.reloadData()
        })
    }
}

// MARK: - Private
private extension MyQOTAdminEditSprintsViewController {
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

// MARK: - TableView delegates
extension MyQOTAdminEditSprintsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.getDatasourceCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyQotProfileOptionsTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: interactor.getSprint(at: indexPath.row).title ?? String.empty,
                       subtitle: interactor.getSprint(at: indexPath.row).subtitle ?? String.empty)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        router.openSprintDetails(for: interactor.getSprint(at: indexPath.row))
    }
}

// MARK: - MyQOTAdminEditSprintsViewControllerInterface
extension MyQOTAdminEditSprintsViewController: MyQOTAdminEditSprintsViewControllerInterface {
    func setupView() {
        updateBottomNavigation([backNavigationItem()], [])
    }
}
