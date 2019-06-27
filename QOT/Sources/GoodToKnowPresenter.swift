//
//  GoodToKnowPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 25.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class GoodToKnowPresenter {

    // MARK: - Properties

    private weak var viewController: GoodToKnowViewControllerInterface?

    // MARK: - Init

    init(viewController: GoodToKnowViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - GoodToKnowInterface

extension GoodToKnowPresenter: GoodToKnowPresenterInterface {
}
