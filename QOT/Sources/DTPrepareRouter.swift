//
//  DTPrepareRouter.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import qot_dal

final class DTPrepareRouter: DTRouter {

    // MARK: - Properties
    weak var prepareViewController: DTPrepareViewController?
}

// MARK: - DTPrepareRouterInterface
extension DTPrepareRouter: DTPrepareRouterInterface {
    func didUpdatePrepareResults() {
        dismissResultView()
    }

    func dismissResultView() {
        viewController?.dismiss(animated: true)
    }

    func loadShortTBVGenerator(introKey: String, delegate: DTShortTBVDelegate?, completion: (() -> Void)?) {
        let configurator = DTShortTBVConfigurator.make(introKey: introKey, delegate: delegate)
        let controller = DTShortTBVViewController(configure: configurator)
        viewController?.present(controller, animated: true, completion: completion)
    }

    func presentPrepareResults(_ preparation: QDMUserPreparation?) {
        let configurator = ResultsPrepareConfigurator.make(preparation, resultType: .prepareDecisionTree)
        let controller = ResultsPrepareViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }
}
