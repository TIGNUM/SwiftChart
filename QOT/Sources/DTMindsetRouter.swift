//
//  DTMindsetRouter.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTMindsetRouter: DTRouter {}

// MARK: - DTMindsetRouterInterface
extension DTMindsetRouter: DTMindsetRouterInterface {
    func presentMindsetResults(_ mindsetShifter: QDMMindsetShifter?, completion: (() -> Void)?) {
        let configurator = ShifterResultConfigurator.make(mindsetShifter: mindsetShifter)
        let controller = ShifterResultViewController(configure: configurator)
        viewController?.present(controller, animated: true, completion: completion)
    }

    func loadShortTBVGenerator(introKey: String, delegate: DTShortTBVDelegate?, completion: (() -> Void)?) {
        let configurator = DTShortTBVConfigurator.make(introKey: ShortTBV.QuestionKey.IntroMindSet, delegate: delegate)
        let controller = DTShortTBVViewController(configure: configurator)
        viewController?.present(controller, animated: true, completion: completion)
    }
}
