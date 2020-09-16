//
//  TeamToBeVisionOptionsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamToBeVisionOptionsViewController: UIViewController {

    // MARK: - Properties
    var interactor: TeamToBeVisionOptionsInteractorInterface!
    private lazy var router: TeamToBeVisionOptionsRouterInterface = TeamToBeVisionOptionsRouter(viewController: self)
    @IBOutlet private weak var headerView: UIView!
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var tableView: UITableView!
    private var pageType: TeamToBeVisionOptionsModel.Types!

    // MARK: - Init
    init(configure: Configurator<TeamToBeVisionOptionsViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        interactor.viewDidLoad()
        tableView.registerDequeueable(TeamToBeVisionOptionTableViewCell.self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(color: .carbon)
    }
}

// MARK: - TeamToBeVisionOptionsViewControllerInterface
extension TeamToBeVisionOptionsViewController: TeamToBeVisionOptionsViewControllerInterface {

    func setupView(type: TeamToBeVisionOptionsModel.Types, remainingDays: Int) {
        pageType = type
        baseHeaderView?.configure(title: type.pageTitle, subtitle: "Ends")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TeamToBeVisionOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.getType.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TeamToBeVisionOptionTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: pageType.titleForItem(at: indexPath), cta: pageType.ctaForItem(at: indexPath))
        return cell
    }
}
