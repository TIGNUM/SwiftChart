//
//  GuidedStoryViewController.swift
//  QOT
//
//  Created by karmic on 26.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class GuidedStoryViewController: UIViewController {

    // MARK: - Properties
    var interactor: GuidedStoryInteractorInterface!
    private weak var router: GuidedStoryRouterInterface = GuidedStoryRouter(viewController: self)

    // MARK: - Init
    init(configure: Configurator<GuidedStoryViewController>) {
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
private extension GuidedStoryViewController {

}

// MARK: - Actions
private extension GuidedStoryViewController {

}

// MARK: - GuidedStoryViewControllerInterface
extension GuidedStoryViewController: GuidedStoryViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
