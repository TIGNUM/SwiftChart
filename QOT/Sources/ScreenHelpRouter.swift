//
//  ScreenHelpRouter.swift
//  QOT
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

class ScreenHelpRouter {
    private let windowManager: WindowManager
    private weak var viewController: (ScreenHelpViewControllerInterface & UIViewControllerInterface)?

    init(windowManager: WindowManager, viewController: ScreenHelpViewControllerInterface & UIViewControllerInterface) {
        self.windowManager = windowManager
        self.viewController = viewController
    }
}

// MARK: - ScreenHelpRouterInterface

extension ScreenHelpRouter: ScreenHelpRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: { [unowned self] in
            self.windowManager.resignWindow(atLevel: .priority)
        })
    }

    func showVideo(with url: URL) {
        viewController?.streamVideo(videoURL: url)
    }
}
