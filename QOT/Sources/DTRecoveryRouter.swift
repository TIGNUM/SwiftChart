//
//  DTRecoveryRouter.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTRecoveryRouter: DTRouter {}

// MARK: - DTRecoveryRouterInterface
extension DTRecoveryRouter: DTRecoveryRouterInterface {
    func presentRecoveryResults(_ recovery: QDMRecovery3D?, _ completion: (() -> Void)?) {
        let configurator = SolveResultsConfigurator.make(from: recovery, resultType: .recoveryDecisionTree)
        let controller = SolveResultsViewController(configure: configurator)
        controller.resultDelegate = self
        viewController?.present(controller, animated: true, completion: completion)
    }
}
