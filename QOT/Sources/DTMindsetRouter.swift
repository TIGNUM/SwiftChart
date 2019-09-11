//
//  DTMindsetRouter.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTMindsetRouter: DTRouter {}

// MARK: - DTMindsetRouterInterface
extension DTMindsetRouter: DTMindsetRouterInterface {
    func presentMindsetResults() {

    }

    func loadShortTBVGenerator(introKey: String, delegate: DTMindsetInteractorInterface?, completion: (() -> Void)?) {
        let configurator = DTShortTBVConfigurator.make(introKey: ShortTBV.QuestionKey.IntroMindSet, delegate: delegate)
        let controller = DTShortTBVViewController(configure: configurator)
        viewController?.present(controller, animated: true, completion: completion)
    }
}
