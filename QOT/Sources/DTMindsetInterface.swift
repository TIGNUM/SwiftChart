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
}

protocol DTMindsetRouterInterface {
    func loadShortTBVGenerator(introKey: String, delegate: DTMindsetInteractorInterface?, completion: (() -> Void)?)
}
