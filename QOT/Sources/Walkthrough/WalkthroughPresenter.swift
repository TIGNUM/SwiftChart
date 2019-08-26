//
//  WalkthroughPresenter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughPresenter {

    // MARK: - Properties

    private weak var viewController: WalkthroughViewControllerInterface?

    // MARK: - Init

    init(viewController: WalkthroughViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - WalkthroughInterface

extension WalkthroughPresenter: WalkthroughPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func present(controller: UIViewController) {
        viewController?.show(controller: controller)
    }
}
