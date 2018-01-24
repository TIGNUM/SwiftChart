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
        setModel(model: nil)
    }

    func present(model: Guide.Model) {
        setModel(model: model)
    }

    private func setModel(model: Guide.Model?) {
        guard model != self.model, let viewController = viewController else { return }

        if let model = model {
            viewController.setLoading(false)
            viewController.updateHeader(greeting: model.greeting, message: model.message)
            viewController.updateDays(days: model.days)
        } else {
            viewController.setLoading(true)
            viewController.updateHeader(greeting: "", message: "")
            viewController.updateDays(days: [])
        }
    }
}
