//
//  ResultsPrepareRouter.swift
//  QOT
//
//  Created by karmic on 11.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ResultsPrepareRouter {

    // MARK: - Properties
    private weak var viewController: ResultsPrepareViewController?

    // MARK: - Init
    init(viewController: ResultsPrepareViewController?) {
        self.viewController = viewController
    }
}

// MARK: - ResultsPrepareRouterInterface
extension ResultsPrepareRouter: ResultsPrepareRouterInterface {
    func presentDTEditView(_ viewModel: DTViewModel, question: QDMQuestion?) {
        let configurator = DTPrepareConfigurator.make(viewModel: viewModel, question: question)
        let controller = DTPrepareViewController(configure: configurator)
        controller.delegate = viewController
        viewController?.present(controller, animated: true)
    }

    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func presentContent(_ contentId: Int) {
        AppDelegate.current.launchHandler.showContentCollection(contentId)
    }

    func presentEditStrategyView(_ relatedStrategyId: Int, _ selectedIDs: [Int]) {
        let configurator = ChoiceConfigurator.make(selectedIDs, relatedStrategyId)
        let controller = ChoiceViewController(configure: configurator)
        controller.delegate = viewController
        viewController?.present(controller, animated: true)
    }
}
