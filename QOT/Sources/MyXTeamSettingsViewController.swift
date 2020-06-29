//
//  MyXTeamSettingsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 29.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class MyXTeamSettingsViewController: UIViewController {

    // MARK: - Properties
    var interactor: MyXTeamSettingsInteractorInterface?
    var router: MyXTeamSettingsRouterInterface?

    // MARK: - Init
    init(configure: Configurator<MyXTeamSettingsViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - Private
private extension MyXTeamSettingsViewController {

}

// MARK: - Actions
private extension MyXTeamSettingsViewController {

}

// MARK: - MyXTeamSettingsViewControllerInterface
extension MyXTeamSettingsViewController: MyXTeamSettingsViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
