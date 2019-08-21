//
//  MyDataSelectionViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyDataSelectionViewController: UIViewController {

    // MARK: - Properties
    var interactor: MyDataSelectionInteractorInterface?
    var router: MyDataSelectionRouterInterface?

    // MARK: - Init
    init(configure: Configurator<MyDataSelectionViewController>) {
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
private extension MyDataSelectionViewController {

}

// MARK: - Actions
private extension MyDataSelectionViewController {

}

// MARK: - MyDataSelectionViewControllerInterface
extension MyDataSelectionViewController: MyDataSelectionViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
