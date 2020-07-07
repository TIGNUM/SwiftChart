//
//  halloViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 07.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class halloViewController: UIViewController {

    // MARK: - Properties
    var interactor: halloInteractorInterface!
    private lazy var router: halloRouterInterface = halloRouter(viewController: self)

    // MARK: - Init
    init(configure: Configurator<halloViewController>) {
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
private extension halloViewController {

}

// MARK: - Actions
private extension halloViewController {

}

// MARK: - halloViewControllerInterface
extension halloViewController: halloViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
