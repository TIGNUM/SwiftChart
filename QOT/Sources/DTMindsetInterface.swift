//
//  DTMindsetInterface.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol DTMindsetViewControllerInterface: class {}

protocol DTMindsetPresenterInterface {}

protocol DTMindsetInteractorInterface: Interactor {
    func didDismissShortTBVScene(tbv: QDMToBeVision?)
    func didDismissMindsetResults()
    func getMindsetShifter(_ completion: @escaping (QDMMindsetShifter?) -> Void)
}

protocol DTMindsetRouterInterface {
    func loadShortTBVGenerator(introKey: String, delegate: DTMindsetInteractorInterface?, completion: (() -> Void)?)
    func presentMindsetResults(_ mindsetShifter: QDMMindsetShifter?, completion: (() -> Void)?)
    func dismiss()
}
