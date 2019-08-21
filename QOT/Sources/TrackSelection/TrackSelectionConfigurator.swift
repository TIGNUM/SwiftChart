//
//  TrackSelectionConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class TrackSelectionConfigurator: AppStateAccess {
    /// Creates configurator which sets up `TrackSelectionViewController` for presentation
    /// - Parameters:
    ///   - viewController: `TrackSelectionViewController` to be configured
    ///   - navigationController: `UINavigationController` on which the ap will be pushed
    ///   - type: `TrackSelectionType` defines view controller's layout
    static func make() -> (TrackSelectionViewController, UINavigationController, TrackSelectionType) -> Void {
        return { (viewController, navigationController, type) in
            let router = TrackSelectionRouter(viewController: viewController, navigationController: navigationController)
            let worker = TrackSelectionWorker()
            let presenter = TrackSelectionPresenter(viewController: viewController)
            let interactor = TrackSelectionInteractor(worker: worker, presenter: presenter, router: router, type: type)
            viewController.interactor = interactor
        }
    }
}
