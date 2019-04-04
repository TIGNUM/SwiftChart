//
//  LevelThreeViewController.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class LevelThreeViewController: AbstractLevelThreeViewController {

    // MARK: - Properties

    var interactor: LevelThreeInteractorInterface?

    // MARK: - Init

    init(configure: Configurator<LevelThreeViewController>) {
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

private extension LevelThreeViewController {

    func setupView() {

    }
}

// MARK: - Actions

private extension LevelThreeViewController {

}

// MARK: - LevelThreeViewControllerInterface

extension LevelThreeViewController: LevelThreeViewControllerInterface {

}
