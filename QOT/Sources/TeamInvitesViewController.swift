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

    // MARK: - Init
    init(configure: Configurator<TeamInvitesViewController>) {
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
private extension TeamInvitesViewController {

}

// MARK: - Actions
private extension TeamInvitesViewController {

}

// MARK: - TeamInvitesViewControllerInterface
extension TeamInvitesViewController: TeamInvitesViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
