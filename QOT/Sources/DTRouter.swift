//
//  DTRouter.swift
//  QOT
//
//  Created by karmic on 10.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

class DTRouter {

    // MARK: - Properties
    weak var viewController: DTViewController?

    // MARK: - Init
    init(viewController: DTViewController?) {
        self.viewController = viewController
    }
}

// MARK: - DTRouterInterface
extension DTRouter: DTRouterInterface {
    @objc func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func dismissChatBotFlow() {
        AppDelegate.current.launchHandler.dismissChatBotFlow()
    }

    func presentContent(_ contentId: Int) {
        AppDelegate.current.launchHandler.showContentCollection(contentId)
    }

    func playMediaItem(_ contentItemId: Int) {
        AppDelegate.current.launchHandler.showContentItem(contentItemId)
    }
}
