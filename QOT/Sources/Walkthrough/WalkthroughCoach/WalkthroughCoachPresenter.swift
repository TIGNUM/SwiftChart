//
//  WalkthroughCoachPresenter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 23/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughCoachPresenter {

    // MARK: - Properties

    private weak var viewController: WalkthroughCoachViewControllerInterface?

    // MARK: - Init

    init(viewController: WalkthroughCoachViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - WalkthroughCoachInterface

extension WalkthroughCoachPresenter: WalkthroughCoachPresenterInterface {

    func setupView() {
        viewController?.setupView()
    }
}
