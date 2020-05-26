//
//  FeatureExplainerViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 26.05.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class FeatureExplainerViewController: UIViewController {

    // MARK: - Properties
    var interactor: FeatureExplainerInteractorInterface?
    var router: FeatureExplainerRouterInterface?

    // MARK: - Init
    init(configure: Configurator<FeatureExplainerViewController>) {
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
private extension FeatureExplainerViewController {

}

// MARK: - Actions
private extension FeatureExplainerViewController {

}

// MARK: - FeatureExplainerViewControllerInterface
extension FeatureExplainerViewController: FeatureExplainerViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
