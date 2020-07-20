//
//  MyXTeamMembersViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyXTeamMembersViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties
    var interactor: MyXTeamMembersInteractorInterface!
    private lazy var router = MyXTeamMembersRouter(viewController: self)
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    private var teamHeaderItems = [Team.Item]()
    @IBOutlet private weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var horizontalHeaderView: HorizontalHeaderView!
    private var rightBarButtonItems = [UIBarButtonItem]()

    private lazy var addMembersButton: UIBarButtonItem = {
        let button = RoundedButton(title: nil, target: self, action: #selector(addMembers))
        let title = AppTextService.get(.settings_team_settings_team_members_add_members)
        ThemableButton.myTbvDataRate.apply(button, title: title)
        return button.barButton
    }()

    // MARK: - Init
    init(configure: Configurator<MyXTeamMembersViewController>) {
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
        updateBottomNavigation([backNavigationItem()], [addMembersButton])
        setStatusBar(color: .carbon)
        interactor.refreshView()
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return [addMembersButton]
    }
}

// MARK: - Private
private extension MyXTeamMembersViewController {
    @objc func addMembers() {
        router.addMembers(team: interactor.selectedTeam)
    }
}

// MARK: - Actions
private extension MyXTeamMembersViewController {

}

// MARK: - MyXTeamMembersViewControllerInterface
extension MyXTeamMembersViewController: MyXTeamMembersViewControllerInterface {

    func setupView() {
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        ThemeView.level3.apply(tableView)
        tableView.registerDequeueable(TeamMemberTableViewCell.self)
        tableView.tableFooterView = UIView()
        ThemeView.level3.apply(view)
        baseHeaderView?.configure(title: interactor?.teamMembersText, subtitle: nil)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? 0
    }

    func updateTeamHeader(teamHeaderItems: [Team.Item]) {
        self.teamHeaderItems = teamHeaderItems
        horizontalHeaderView.configure(headerItems: teamHeaderItems)
    }

    func updateView() {
        tableView.reloadData()
    }
}

extension MyXTeamMembersViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.rowCount
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let member = interactor.getMember(at: indexPath) else {
            fatalError("member does not exist at indexPath: \(indexPath.item)")
        }

        let adminText = AppTextService.get(.settings_team_settings_team_members_admin_label)
        let cell: TeamMemberTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(memberEmail: member.isTeamOwner ? (member.email ?? "") + " " + adminText : member.email, memberStatus: member.status)
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let inviteAgain = AppTextService.get(.settings_team_settings_team_members_invite_again)

        let inviteAgainAction = UITableViewRowAction(style: .normal, title: inviteAgain) {(action, indexPath) in
            self.interactor.reinviteMember(at: indexPath)
        }
        inviteAgainAction.backgroundColor = .accent10
        let invited = AppTextService.get(.settings_team_settings_team_members_invited)
        let invitedAction = UITableViewRowAction(style: .normal, title: invited) {(action, indexPath) in

        }
        invitedAction.backgroundColor = .accent10
        let remove = AppTextService.get(.settings_team_settings_team_members_remove)

        let removeAction = UITableViewRowAction(style: .normal, title: remove) { (action, indexPath) in
            self.interactor.removeMember(at: indexPath)
        }
        removeAction.backgroundColor = .redOrange
        guard let member = interactor.getMember(at: indexPath) else {
            fatalError("member does not exist at indexPath: \(indexPath.item)")
        }
        switch member.status {
        case .joined:
            return [removeAction]
        case .pending:
            return member.wasReinvited ? [removeAction, invitedAction] : [removeAction, inviteAgainAction]
        }
    }
// CHECK IF OWNER

//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        guard let isOwner = interactor?.selectedTeam?.thisUserIsOwner else { return false}
//        return isOwner
//
//    }

}
