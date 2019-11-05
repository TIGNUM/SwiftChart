//
//  CoachMarksRouter.swift
//  QOT
//
//  Created by karmic on 22.10.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class CoachMarksRouter {

    // MARK: - Properties
    private weak var viewController: CoachMarksViewController?
    private var trackType: SelectedTrackType

    // MARK: - Init
    init(viewController: CoachMarksViewController?, trackType: SelectedTrackType) {
        self.viewController = viewController
        self.trackType = trackType
    }
}

// MARK: - CoachMarksRouterInterface
extension CoachMarksRouter: CoachMarksRouterInterface {
    func navigateToTrack() {
        // Show app
        viewController?.dismiss(animated: true)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.appCoordinator.showApp()
        // Guided
        if case .guided = trackType, let url = URLScheme.dailyBriefURL(for: .GUIDE_TRACK) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
