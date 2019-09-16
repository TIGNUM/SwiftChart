//
//  WalkthroughInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol WalkthroughViewControllerInterface: class {
    func setupView()
    func show(controller: UIViewController)
}

protocol WalkthroughPresenterInterface {
    func setupView()
    func present(controller: UIViewController)
}

protocol WalkthroughInteractorInterface: Interactor {
    var buttonGotItTitle: String { get }
    var firstController: UIViewController { get }
    var controllerCount: Int { get }
    func index(of controller: UIViewController?) -> Int?
    func viewController(after controller: UIViewController) -> UIViewController
    func viewController(before controller: UIViewController) -> UIViewController
    func didTapGotIt()
}

protocol WalkthroughRouterInterface {
    func navigateToTrack(type: SelectedTrackType)
}
