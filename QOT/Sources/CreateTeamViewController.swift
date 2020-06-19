//
//  CreateTeamViewController.swift
//  QOT
//
//  Created by karmic on 19.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class CreateTeamViewController: UIViewController {

    // MARK: - Properties
    var interactor: CreateTeamInteractorInterface!
    private weak var router: CreateTeamRouterInterface = CreateTeamRouter(viewController: self)

    // MARK: - Init
    init(configure: Configurator<CreateTeamViewController>) {
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
private extension CreateTeamViewController {

}

// MARK: - Actions
private extension CreateTeamViewController {

}

// MARK: - CreateTeamViewControllerInterface
extension CreateTeamViewController: CreateTeamViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
