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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBottomNavigation([backNavigationItem()], [])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBottomNavigation([], [])
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
        tableView.tableFooterView = UIView()
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
        switch TeamInvite.Section(rawValue: indexPath.section) {
        case .header?:
            let headerCell: TeamInviteHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            let item = interactor.headerItem()
            headerCell.configure(header: item.header?.title,
                                 content: item.header?.content,
                                 teamCount: item.header?.teamCounter(partOfTeams: item.teamCount),
                                 note: item.header?.noteText)
            return headerCell

        case .invite?:
            let item = interactor.inviteItem(at: indexPath.row)
            let inviteCell: TeamInvitePendingTableViewCell = tableView.dequeueCell(for: indexPath)
            inviteCell.configure(teamName: item.team?.name ?? "",
                                 teamColor: item.team?.teamColor ?? "",
                                 teamId: item.team?.qotId ?? "",
                                 sender: item.sender ?? "",
                                 dateOfInvite: item.invitedDate ?? Date(),
                                 memberCount: 0,
                                 invite: item)
            return inviteCell
        case .none:
            fatalError("Invalid section for TeamInvite.Section at indexPath: \(indexPath)")
        }
    }
}
