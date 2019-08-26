//
//  WalkthroughSwipePresenter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 23/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughSwipePresenter {

    // MARK: - Properties

    private weak var viewController: WalkthroughSwipeViewControllerInterface?

    // MARK: - Init

    init(viewController: WalkthroughSwipeViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - WalkthroughSwipeInterface

extension WalkthroughSwipePresenter: WalkthroughSwipePresenterInterface {

    func setupView() {
        viewController?.setupView()
    }
}
