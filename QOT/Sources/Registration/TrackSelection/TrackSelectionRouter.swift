//
//  TrackSelectionRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class TrackSelectionRouter {

    // MARK: - Properties

    private let viewController: TrackSelectionViewController

    // MARK: - Init

    init(viewController: TrackSelectionViewController) {
        self.viewController = viewController
    }
}

// MARK: - TrackSelectionRouterInterface

extension TrackSelectionRouter: TrackSelectionRouterInterface {

    func openWalktrough(with trackType: SelectedTrackType) {
        guard let controller = R.storyboard.walkthrough.walkthroughViewController() else { return }
        let configurator = WalkthroughConfigurator.make()
        configurator(controller, trackType)
        viewController.pushToStart(childViewController: controller)
    }

    func showLocationPersmission(completion: (() -> Void)?) {
        let configurator = NotificationPermissionConfigurator.make()
        guard let controller = R.storyboard.notificationPermission.notificationPermissionViewController() else { return }
        configurator(controller)
        viewController.present(controller, animated: true, completion: completion)
    }
}
