//
//  MyDataExplanationViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyDataExplanationViewController: UIViewController {

    // MARK: - Properties
    var interactor: MyDataExplanationInteractorInterface?
    var router: MyDataExplanationRouterInterface?

    // MARK: - Init
    init(configure: Configurator<MyDataExplanationViewController>) {
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
private extension MyDataExplanationViewController {

}

// MARK: - Actions
private extension MyDataExplanationViewController {

}

// MARK: - MyDataExplanationViewControllerInterface
extension MyDataExplanationViewController: MyDataExplanationViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
