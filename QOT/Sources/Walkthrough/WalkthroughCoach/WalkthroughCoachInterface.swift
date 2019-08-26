//
//  WalkthroughCoachInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 23/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol WalkthroughCoachViewControllerInterface: class {
    func setupView()
}

protocol WalkthroughCoachPresenterInterface {
    func setupView()
}

protocol WalkthroughCoachInteractorInterface: Interactor {
    var text: String { get }
}

protocol WalkthroughCoachRouterInterface {}
