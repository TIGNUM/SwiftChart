//
//  MyDataExplanationViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyDataExplanationViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties
    var interactor: MyDataExplanationInteractorInterface?
    var router: MyDataExplanationRouterInterface?

    private var baseView: QOTBaseHeaderView?
    @IBOutlet private weak var tableView: UITableView!
    private var myDataExplanationModel: MyDataExplanationModel?

    // MARK: - Init
    init(configure: Configurator<MyDataExplanationViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }
}

// MARK: - UITableView Delegate and Datasource
extension MyDataExplanationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataExplanationModel?.myDataExplanationItems.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyDataExplanationScreenTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(forExplanationItem: myDataExplanationModel?.myDataExplanationItems[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 80))
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return baseView
    }
}

// MARK: - Private
private extension MyDataExplanationViewController {
    func setupTableView() {
        tableView.registerDequeueable(MyDataExplanationScreenTableViewCell.self)
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 150
        tableView.separatorInset = .zero
        tableView.separatorColor = .sand30
        tableView.allowsSelection = false
    }
}

// MARK: - MyDataExplanationViewControllerInterface
extension MyDataExplanationViewController: MyDataExplanationViewControllerInterface {
    func setupView() {
        setupTableView()
        ThemeView.level3.apply(view)
        ThemeView.level3.apply(tableView)

    }

    func setup(for myDataExplanationSection: MyDataExplanationModel, myDataExplanationHeaderTitle: String) {
        myDataExplanationModel = myDataExplanationSection
        if let headerView = R.nib.qotBaseHeaderView.firstView(owner: self) {
            headerView.configure(title: myDataExplanationHeaderTitle, subtitle: nil)
            baseView = headerView
            ThemeView.level3.apply(headerView)
        }
    }
}
