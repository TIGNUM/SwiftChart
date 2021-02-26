//
//  MyQOTAdminChooseBucketsViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 18/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQOTAdminChooseBucketsViewController: BaseViewController {

    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?

    var interactor: MyQOTAdminChooseBucketsInteractorInterface!
    private lazy var router: MyQOTAdminChooseBucketsRouter! = MyQOTAdminChooseBucketsRouter(viewController: self)

    // MARK: - Init
    init(configure: Configurator<MyQOTAdminChooseBucketsViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        MyQOTAdminChooseBucketsConfigurator.configure(viewController: self)
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
        interactor.showSelectedBucketsInDailyBrief()
        router.dismiss()
    }
}

// MARK: - Private
private extension MyQOTAdminChooseBucketsViewController {
    func setupTableView() {
        ThemeView.level2.apply(view)
        ThemeView.level2.apply(tableView)
        ThemeView.level2.apply(headerView)
        tableView.registerDequeueable(MyQotProfileOptionsTableViewCell.self)
        ThemeView.level2.apply(self.view)
        baseHeaderView?.configure(title: interactor.getHeaderTitle(),
                                  subtitle: nil)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? .zero

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView.headerView(with: .level2)
        tableView.reloadData()
    }
}

// MARK: - TableView delegates
extension MyQOTAdminChooseBucketsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.getDatasourceCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyQotProfileOptionsTableViewCell = tableView.dequeueCell(for: indexPath)
        let isSelected = interactor.isSelected(at: indexPath.row)
        let checkMark = R.image.registration_checkmark()

        cell.configure(title: interactor.getBucketTitle(at: indexPath.row),
                       subtitle: nil)
        cell.customAccessoryImageView.image = isSelected ? checkMark : nil

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        interactor.setSelected(!interactor.isSelected(at: indexPath.row),
                               at: indexPath.row)
        tableView.reloadData()
    }
}

// MARK: - MyQOTAdminChooseBucketsViewControllerInterface
extension MyQOTAdminChooseBucketsViewController: MyQOTAdminChooseBucketsViewControllerInterface {
    func setupView() {
        let rightButtons = [roundedBarButtonItem(title: interactor.getDoneButtonTitle(),
                                               buttonWidth: .Done,
                                               action: #selector(doneAction),
                                               backgroundColor: .black,
                                               borderColor: .white)]
        updateBottomNavigation([backNavigationItem()], rightButtons)
    }
}
