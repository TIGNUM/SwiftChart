//
//  NotificationSettingsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 03.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class NotificationSettingsViewController: UIViewController {

    // MARK: - Properties
    var interactor: NotificationSettingsInteractorInterface!
    private lazy var router: NotificationSettingsRouterInterface = NotificationSettingsRouter(viewController: self)

    // MARK: - Init
    init(configure: Configurator<NotificationSettingsViewController>) {
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
private extension NotificationSettingsViewController {

}

// MARK: - Actions
private extension NotificationSettingsViewController {

}

// MARK: - NotificationSettingsViewControllerInterface
extension NotificationSettingsViewController: NotificationSettingsViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
