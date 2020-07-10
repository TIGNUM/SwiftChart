//
//  MyXTeamMembersViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

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
}

// MARK: - Private
private extension MyXTeamMembersViewController {

}

// MARK: - Actions
private extension MyXTeamMembersViewController {

}

// MARK: - MyXTeamMembersViewControllerInterface
extension MyXTeamMembersViewController: MyXTeamMembersViewControllerInterface {

    func setupView() {
        ThemeView.level3.apply(view)
        membersList = [MyXTeamMemberModel(email: "a.plancoulaine@tignum.com", status: .joined, qotId: "2ER5", isTeamOwner: true), MyXTeamMemberModel(email: "b.hallo@gmail.com", status: .joined, qotId: "AB3C", isTeamOwner: false), MyXTeamMemberModel(email: "pattismith@vam.com", status: .pending, qotId: "9J78", isTeamOwner: false)]
        baseHeaderView?.configure(title: interactor?.teamMembersText, subtitle: nil)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? 0
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
        let cell: TeamMemberTableViewCell = tableView.dequeueCell(for:indexPath)
        cell.configure(memberEmail: member.email , memberStatus: member.status)
        return cell
    }
}
