//
//  MyXTeamMembersViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyXTeamMembersViewController: UIViewController {

    // MARK: - Properties
    var interactor: MyXTeamMembersInteractorInterface!
    private lazy var router = MyXTeamMembersRouter(viewController: self)
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    private var teamHeaderItems = [TeamHeader]()
    @IBOutlet private weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var horizontalHeaderView: HorizontalHeaderView!
    @IBOutlet weak var horizontalHeaderHeight: NSLayoutConstraint!
    var membersList: [MyXTeamMemberModel] = []
    private var leftBarButtonItems = [UIBarButtonItem]()

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
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        ThemeView.level3.apply(tableView)
        tableView.registerDequeueable(TeamMemberTableViewCell.self)
        tableView.tableFooterView = UIView()
        interactor.viewDidLoad()
    }


    // MARK: Bottom Navigation
    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return leftBarButtonItems
    }
}

// MARK: - Private
private extension MyXTeamMembersViewController {

    func backToTeamSettings() -> UIBarButtonItem {
         return backNavigationItem()
    }

    func reinviteMember(indexPath: IndexPath) {
        if let email = membersList.at(index: indexPath.row)?.email, let team = interactor.selectedTeam {
            interactor.reinviteMember(email: email, team: team)
            //           TODO  update member model
        }
        //        TEMP
        membersList[indexPath.row].wasReinvited.toggle()
        tableView.reloadData()

    }

    func removeMember(indexPath: IndexPath) {
        if let memberId = membersList.at(index: indexPath.row)?.qotId, let team = interactor.selectedTeam {
            interactor.removeMember(memberId: memberId, team: team)
            //          TO DO
        }
        //         TEMP
        membersList.remove(at: indexPath.row)
        tableView.reloadData()
    }
}

// MARK: - Actions
private extension MyXTeamMembersViewController {

}

// MARK: - MyXTeamMembersViewControllerInterface
extension MyXTeamMembersViewController: MyXTeamMembersViewControllerInterface {

    func setupView() {
        ThemeView.level3.apply(view)
        membersList = [MyXTeamMemberModel(email: "a.plancoulaine@tignum.com", status: .joined, qotId: "2ER5", isTeamOwner: true, wasReinvited: false), MyXTeamMemberModel(email: "b.hallo@gmail.com", status: .joined, qotId: "AB3C", isTeamOwner: false, wasReinvited: false), MyXTeamMemberModel(email: "pattismith@vam.com", status: .pending, qotId: "9J78", isTeamOwner: false, wasReinvited: false)]
        baseHeaderView?.configure(title: interactor?.teamMembersText, subtitle: nil)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? 0
        updateBottomNavigation([backNavigationItem()],[])
    }

    func updateTeamHeader(teamHeaderItems: [TeamHeader]) {
        self.teamHeaderItems = teamHeaderItems
        teamHeaderItems.isEmpty ? horizontalHeaderHeight.constant = 0 : horizontalHeaderView.configure(headerItems: teamHeaderItems)
    }

    func updateView() {
        tableView.reloadData()
    }
}

extension MyXTeamMembersViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return membersList.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let member = membersList.at(index: indexPath.row) else {
            fatalError("member does not exist at indexPath: \(indexPath.item)")
        }
        let cell: TeamMemberTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(memberEmail: member.email, memberStatus: member.status)
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        guard let isOwner = interactor?.selectedTeam?.thisUserIsOwner else { return [UITableViewRowAction()]}
//            if isOwner == true {
                let inviteAgain = AppTextService.get(.settings_team_settings_team_members_invite_again)
                let inviteAgainAction = UITableViewRowAction(style: .normal, title: inviteAgain) {(action, indexPath) in
                    self.reinviteMember(indexPath: indexPath)
                }
                inviteAgainAction.backgroundColor = .accent10
                let invited = AppTextService.get(.settings_team_settings_team_members_invited)
                let invitedAction = UITableViewRowAction(style: .normal, title: invited) {(action, indexPath) in

                }
                invitedAction.backgroundColor = .accent10
                let remove = AppTextService.get(.settings_team_settings_team_members_remove)

                let removeAction = UITableViewRowAction(style: .normal, title: remove) { (action, indexPath) in
                    self.removeMember(indexPath: indexPath)
                }
                removeAction.backgroundColor = .redOrange
                guard let member = membersList.at(index: indexPath.row) else {
                    fatalError("member does not exist at indexPath: \(indexPath.item)")
                }
                switch member.status {
                case .joined:
                    return [removeAction]
                case .pending:
                    return member.wasReinvited ? [removeAction, invitedAction] : [removeAction, inviteAgainAction]
                }
//            } else {
//                return .none
//        }
    }
}
