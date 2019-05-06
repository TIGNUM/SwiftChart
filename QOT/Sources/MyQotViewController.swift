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
    weak var delegate: CoachPageViewControllerDelegate?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - Private

private extension MyQotViewController {

}

// MARK: - Actions

private extension MyQotViewController {

}

// MARK: - MyQotViewControllerInterface

extension MyQotViewController: MyQotViewControllerInterface {
    func setupView() {
        view.backgroundColor = .green
    }
}
