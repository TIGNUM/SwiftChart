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
    init(configure: Configurator<MyQOTAdminEditSprintsDetailsViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

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
//        let isSelected = interactor.isSelected(at: indexPath.row)
        let checkMark = R.image.registration_checkmark()

//        cell.configure(title: interactor.getBucketTitle(at: indexPath.row),
//                       subtitle: nil)
//        cell.customAccessoryImageView.image = isSelected ? checkMark : nil

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        interactor.setSelected(!interactor.isSelected(at: indexPath.row),
//                               at: indexPath.row)
        tableView.reloadData()
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
