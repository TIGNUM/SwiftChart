//
//  ThoughtsPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ThoughtsPresenter {

    // MARK: - Properties

    private weak var viewController: ThoughtsViewControllerInterface?

    // MARK: - Init

    init(viewController: ThoughtsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - ThoughtsInterface

extension ThoughtsPresenter: ThoughtsPresenterInterface {
}
