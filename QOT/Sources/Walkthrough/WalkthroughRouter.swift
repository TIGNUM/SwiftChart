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

    private weak var viewController: WalkthroughViewController?

    // MARK: - Init

    init(viewController: WalkthroughViewController) {
        self.viewController = viewController
    }
}

// MARK: - WalkthroughRouterInterface

extension WalkthroughRouter: WalkthroughRouterInterface {
    func navigateToTrack(type: SelectedTrackType) {
        // Show app
        viewController?.dismiss(animated: true)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.appCoordinator.showApp()
        // Guided
        if case .guided = type, let url = URLScheme.dailyBriefURL(for: .GUIDE_TRACK) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
