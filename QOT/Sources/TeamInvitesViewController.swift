//
//  TeamInvitesViewController.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamInvitesViewController: UIViewController {

    // MARK: - Properties
    var interactor: TeamInvitesInteractorInterface!
    private lazy var router: TeamInvitesRouterInterface = TeamInvitesRouter(viewController: self)
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Init
    init(configure: Configurator<TeamInvitesViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
    }
}

// MARK: - Private
private extension TeamInvitesViewController {

}

// MARK: - Actions
private extension TeamInvitesViewController {

}

// MARK: - TeamInvitesViewControllerInterface
extension TeamInvitesViewController: TeamInvitesViewControllerInterface {
    func setupView() {
        tableView.registerDequeueable(TeamInviteHeaderTableViewCell.self)
        tableView.registerDequeueable(TeamInvitePendingTableViewCell.self)
    }

    func reload() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TeamInvitesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.rowCount(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let headerItem = interactor.headerItem()
            let headerCell: TeamInviteHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            headerCell.configure(header: headerItem?.title ?? "", content: headerItem?.content ?? "")
            return headerCell

        case 1:
            let item = interactor.inviteItem(at: indexPath.row)
            let inviteCell: TeamInvitePendingTableViewCell = tableView.dequeueCell(for: indexPath)
            inviteCell.configure(teamName: item.teamName,
                                 teamColor: item.teamColor,
                                 teamId: item.teamQotId,
                                 sender: item.sender,
                                 dateOfInvite: item.dateOfInvite,
                                 memberCount: item.memberCount)
            return inviteCell
        default:
            fatalError("Invalid section")
        }
    }
}
