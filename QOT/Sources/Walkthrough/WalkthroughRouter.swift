//
//  WalkthroughRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughRouter {

    // MARK: - Properties

    private let viewController: WalkthroughViewController

    // MARK: - Init

    init(viewController: WalkthroughViewController) {
        self.viewController = viewController
    }
}

// MARK: - WalkthroughRouterInterface

extension WalkthroughRouter: WalkthroughRouterInterface {
    func navigateToTrack(type: SelectedTrackType) {
        switch type {
        case .fast:
            showFastTrack()
        case .guided:
            showGuidedTrack()
        }
    }
}

private extension WalkthroughRouter {
    func showFastTrack() {
        viewController.dismiss(animated: true) { }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.appCoordinator.showApp(with: .dailyBrief)
    }

    func showGuidedTrack() {
        // TODO: https://tignum.atlassian.net/browse/QOT-1639
        viewController.dismiss(animated: true) { }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.appCoordinator.showApp(with: .dailyBrief)
    }
}
