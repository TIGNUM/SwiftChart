//
//  WalkthroughSearchPresenter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughSearchPresenter {

    // MARK: - Properties

    private weak var viewController: WalkthroughSearchViewControllerInterface?

    // MARK: - Init

    init(viewController: WalkthroughSearchViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - WalkthroughSearchInterface

extension WalkthroughSearchPresenter: WalkthroughSearchPresenterInterface {

    func setupView() {
        viewController?.setupView()
    }
}
