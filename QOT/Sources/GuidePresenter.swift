//
//  GuidePresenter.swift
//  QOT
//
//  Created by Sam Wyndham on 24/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class GuidePresenter: GuidePresenterInterface {

    private weak var viewController: GuideViewControllerInterface?
    private var model: Guide.Model?

    init(viewController: GuideViewControllerInterface) {
        self.viewController = viewController
    }

    func presentLoading() {
        guard let viewController = viewController else { return }

        viewController.setLoading(true)
        viewController.updateHeader(greeting: "", message: "", image: nil)
        viewController.updateDays(days: [])
    }

    func present(model: Guide.Model, headerImage: URL?) {
        guard model != self.model, let viewController = viewController else { return }

        viewController.setLoading(false)
        viewController.updateHeader(greeting: model.greeting, message: model.message, image: headerImage)
        viewController.updateDays(days: model.days)
    }
}
