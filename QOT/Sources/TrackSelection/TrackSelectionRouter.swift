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
    private let navigationController: UINavigationController

    // MARK: - Init

    init(viewController: TrackSelectionViewController, navigationController: UINavigationController) {
        self.viewController = viewController
        self.navigationController = navigationController
    }
}

// MARK: - TrackSelectionRouterInterface

extension TrackSelectionRouter: TrackSelectionRouterInterface {

    func showFastTrask() {
        // TODO: https://tignum.atlassian.net/browse/QOT-1648
        showHomeScreen()
    }

    func showGuidedTrack() {
        // TODO: https://tignum.atlassian.net/browse/QOT-1639
        showHomeScreen()
    }
}

// FIXME: ZZ: HARDCODED
private extension TrackSelectionRouter {
    func showHomeScreen() {
        guard let coachCollectionViewController = R.storyboard.main.coachCollectionViewController() else {
            return
        }
        baseRootViewController?.setContent(viewController: coachCollectionViewController)
        baseRootViewController?.dismiss(animated: true, completion: nil)
    }
}
