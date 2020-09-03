//
//  TeamInvitesViewController.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamInvitesViewController: BaseViewController, ScreenZLevel2 {

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
    func headerCell(at indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: TeamInviteHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
        let item = interactor.headerItem()
        cell.configure(header: item.header?.title,
                       content: item.header?.content,
                       teamCount: item.header?.teamCounter,
                       note: item.header?.noteText)
        return cell
    }

    func inviteCell(at indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        guard let item = interactor.pendingInvites(at: indexPath) else {
            fatalError("Invalid item: TeamInvite.Invitation at indexPath: \(indexPath)")
        }
        let cell: TeamInvitePendingTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(pendingInvite: item)
        return cell
    }
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

    func reload(shouldDismiss: Bool) {
        if shouldDismiss {
            didTapBackButton()
        } else {
            tableView.reloadData()
        }
    }

    func showBanner(message: String) {
        let banner = NotificationBanner.instantiateFromNib()
        banner.configure(message: message)
        banner.show(in: self.view)
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
        switch interactor.section(at: indexPath) {
        case .header: return headerCell(at: indexPath, tableView: tableView)
        case .pendingInvite: return inviteCell(at: indexPath, tableView: tableView)
        }
    }
}
