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
    @IBOutlet private weak var headerViewHeightConstraint: NSLayoutConstraint!


    // MARK: - Init
    init(configure: Configurator<MyXTeamMembersViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        // Do any additional setup after loading the view.
    }
}
