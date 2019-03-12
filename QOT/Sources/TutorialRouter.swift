//
//  TutorialRouter.swift
//  QOT
//
//  Created by karmic on 16.11.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class TutorialRouter {

    // MARK: - Properties

    private let viewController: TutorialViewController

    // MARK: - Init

    init(viewController: TutorialViewController) {
        self.viewController = viewController
    }
}

// MARK: - TutorialRouterInterface

extension TutorialRouter: TutorialRouterInterface {

    func dismiss() {
        if viewController.navigationController != nil {
            viewController.navigationController?.popViewController(animated: true)
        } else {
            AppDelegate.current.appCoordinator.showApp()
        }
    }
}
