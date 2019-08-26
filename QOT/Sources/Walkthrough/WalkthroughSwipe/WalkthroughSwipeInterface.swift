//
//  WalkthroughSwipeInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 23/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol WalkthroughSwipeViewControllerInterface: class {
    func setupView()
}

protocol WalkthroughSwipePresenterInterface {
    func setupView()
}

protocol WalkthroughSwipeInteractorInterface: Interactor {
    var text: String { get }
}

protocol WalkthroughSwipeRouterInterface {}
