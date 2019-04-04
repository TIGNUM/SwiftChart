//
//  MyQotViewController.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotViewController: AbstractLevelOneViewConroller {

    // MARK: - Properties

    var interactor: MyQotInteractorInterface?
    weak var delegate: CoachPageViewControllerDelegate?

    // MARK: - Init

    init(configure: Configurator<MyQotViewController>) {
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
