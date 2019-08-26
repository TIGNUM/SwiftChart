//
//  WalkthroughSearchInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol WalkthroughSearchViewControllerInterface: class {
    func setupView()
}

protocol WalkthroughSearchPresenterInterface {
    func setupView()
}

protocol WalkthroughSearchInteractorInterface: Interactor {
    var text: String { get }
}

protocol WalkthroughSearchRouterInterface {}
