//
//  MyQotViewController.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotNavigationController: UINavigationController {
    static var storyboardID = NSStringFromClass(MyQotNavigationController.classForCoder())
}

final class MyQotViewController: AbstractLevelOneViewConroller {

    // MARK: - Properties

    var interactor: MyQotInteractorInterface?
    weak var delegate: CoachCollectionViewControllerDelegate?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        setupTriggerButton()
    }
}

// MARK: - Private

private extension MyQotViewController {

    func setupTriggerButton() {
        let buttonFrame = CGRect(x: 0, y: view.frame.height / 2, width: view.bounds.width, height: 100)
        let button = UIButton(frame: buttonFrame)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(triggerForTesting), for: .touchUpInside)
        button.setTitle("TBV Generator", for: .normal)
        view.addSubview(button)
    }

    @objc func triggerForTesting() {
        let permissionsManager = AppCoordinator.appState.permissionsManager!
        let configurator = DecisionTreeConfigurator.make(for: .toBeVisionGenerator, permissionsManager: permissionsManager)
        let viewController = DecisionTreeViewController(configure: configurator)
        present(viewController, animated: true)
    }
}

// MARK: - MyQotViewControllerInterface

extension MyQotViewController: MyQotViewControllerInterface {
    func setupView() {
        view.backgroundColor = .green
    }
}
