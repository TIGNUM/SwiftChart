//
//  ResultViewController.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ResultViewController: UIViewController {

    // MARK: - Properties
    var interactor: ResultInteractorInterface?
    var router: ResultRouterInterface?

    // MARK: - Init
    init(configure: Configurator<ResultViewController>) {
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
private extension ResultViewController {

}

// MARK: - Actions
private extension ResultViewController {

}

// MARK: - ResultViewControllerInterface
extension ResultViewController: ResultViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
