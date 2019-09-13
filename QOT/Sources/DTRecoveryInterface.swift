//
//  DTRecoveryInterface.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol DTRecoveryViewControllerInterface: class {}

protocol DTRecoveryPresenterInterface {}

protocol DTRecoveryInteractorInterface: Interactor {
    var nextQuestionKey: String? { get set }
    func getRecovery3D(_ completion: @escaping (QDMRecovery3D?) -> Void)
}

protocol DTRecoveryRouterInterface {
    func presentRecoveryResults(_ recovery: QDMRecovery3D?, _ completion: (() -> Void)?)
}
