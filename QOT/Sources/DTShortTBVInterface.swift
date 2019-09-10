//
//  DTShortTBVInterface.swift
//  QOT
//
//  Created by karmic on 10.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol DTShortTBVViewControllerInterface: class {}

protocol DTShortTBVPresenterInterface {}

protocol DTShortTBVInteractorInterface: Interactor {
    func generateTBV(_ completion: @escaping (String) -> Void)
}

protocol DTShortTBVRouterInterface {}
