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
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var horizontalHeaderView: HorizontalHeaderView!

    var rightBarButtonItem: [UIBarButtonItem] {
        return interactor.canEdit ? [addMembersButton] : []
    }

    private lazy var addMembersButton: UIBarButtonItem = {
        let button = RoundedButton(title: nil, target: self, action: #selector(addMembers))
        let title = AppTextService.get(.settings_team_settings_team_members_add_members)
        ThemableButton.darkButton.apply(button, title: title)
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
        updateBottomNavigation([backNavigationItem()], rightBarButtonItem)
        setStatusBar(color: .black)
        interactor.refreshView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return rightBarButtonItem
    }
}

// MARK: - Private
private extension MyXTeamMembersViewController {
    @objc func addMembers() {
        if let team = interactor.getSelectedTeamItem?.qdmTeam {
            router.addMembers(team: team)
        }
    }
}

// MARK: - Actions
private extension MyXTeamMembersViewController {
    func showDemoIfNeeded() {
        let indexPath = IndexPath(row: .zero, section: .zero)

        if let cell = tableView.cellForRow(at: indexPath) as? TeamMemberTableViewCell,
            let member = interactor.getMember(at: indexPath),
            let isOwner = interactor?.canEdit, isOwner, !member.member.me {
            cell.showDemo()
        }
    }
}

// MARK: - MyXTeamMembersViewControllerInterface
extension MyXTeamMembersViewController: MyXTeamMembersViewControllerInterface {

    func setupView() {
        ThemeView.level3.apply(tableView)
        ThemeView.level3.apply(view)

        let baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        baseHeaderView?.configure(title: interactor?.teamMembersText, subtitle: nil)

        tableView.registerDequeueable(TeamMemberTableViewCell.self)
        tableView.tableFooterView = UIView()
    }

    func updateTeamHeader(teamHeaderItems: [Team.Item]) {
        horizontalHeaderView.configure(headerItems: teamHeaderItems, canDeselect: false)
    }

    func updateView(hasMembers: Bool) {
        tableView.beginUpdates()
        tableView.reloadSections(IndexSet(arrayLiteral: .zero), with: .none)
        tableView.endUpdates()
        showDemoIfNeeded()

        if hasMembers {
            updateBottomNavigation([backNavigationItem()], rightBarButtonItem)
        } else {
            router.dismiss()
        }
    }
}

extension MyXTeamMembersViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let member = interactor.getMember(at: indexPath) else {
            fatalError("member does not exist at indexPath: \(indexPath.item)")
        }

        let adminText = AppTextService.get(.settings_team_settings_team_members_admin_label)
        let cell: TeamMemberTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(memberEmail: member.isTeamOwner ? (member.email ?? String.empty) + " " + adminText : member.email,
                       memberStatus: member.status)
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let member = interactor.getMember(at: indexPath) else {
            fatalError("member does not exist at indexPath: \(indexPath.item)")
        }

        let inviteAgain = AppTextService.get(.settings_team_settings_team_members_invite_again)

        let inviteAgainAction = UITableViewRowAction(style: .normal, title: inviteAgain) {(action, indexPath) in
            self.trackUserEvent(.INVITE_MEMBER_AGAIN, value: member.member.remoteID ?? .zero, action: .TAP)
            self.interactor.reinviteMember(at: indexPath)
        }
        inviteAgainAction.backgroundColor = .accent10
        let invited = AppTextService.get(.settings_team_settings_team_members_invited)
        let invitedAction = UITableViewRowAction(style: .normal, title: invited) {(_, _) in

        }
        invitedAction.backgroundColor = .accent10
        let remove = AppTextService.get(.settings_team_settings_team_members_remove)

        let removeAction = UITableViewRowAction(style: .normal, title: remove) { (action, indexPath) in
            let cancel = QOTAlertAction(title: AppTextService.get(.generic_view_button_cancel))
            let remove = QOTAlertAction(title: AppTextService.get(.generic_alert_view_button_remove)) { [weak self] (_) in
                self?.trackUserEvent(.REMOVE_MEMBER, value: member.member.remoteID ?? .zero, action: .TAP)
                self?.interactor.removeMember(at: indexPath)
            }
            QOTAlert.show(title: AppTextService.get(.alert_remove_member_title).replacingOccurrences(of: "${name_of_team}",
                                                                                                     with: self.interactor.getSelectedTeamItem?.title ?? String.empty),
                          message: AppTextService.get(.alert_remove_member_message),
                          bottomItems: [cancel, remove])
        }
        removeAction.backgroundColor = .redOrange
        switch member.status {
        case .joined:
            return [removeAction]
        case .pending:
            return member.wasReinvited ? [removeAction, invitedAction] : [removeAction, inviteAgainAction]
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let member = interactor.getMember(at: indexPath), let isOwner = interactor?.canEdit {
            if isOwner {
                return !member.member.me
            }
            return false
        }
        return false
    }
}
