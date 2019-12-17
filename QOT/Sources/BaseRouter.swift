//
//  BaseRouter.swift
//  QOT
//
//  Created by karmic on 12.12.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol BaseRouterInterface {
    func presentContent(_ contentId: Int)
    func presentMindsetShifter()

    func playMediaItem(_ contentItemId: Int)

    func showHomeScreen()
    func showFAQScreen(category: ContentCategory)
    func showCoachMarks()

    func dismiss()
    func dismissChatBotFlow()
}

class BaseRouter: BaseRouterInterface {

    // MARK: - Properties
    weak var viewController: UIViewController?

    // MARK: - Init
    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - BaseRouterInterface
    func dismiss() {
        viewController?.dismiss(animated: true)
    }

    func dismissChatBotFlow() {
        AppDelegate.current.launchHandler.dismissChatBotFlow()
    }

    func presentContent(_ contentId: Int) {
        AppDelegate.current.launchHandler.showContentCollection(contentId)
    }

    func presentMindsetShifter() {
        let configurator = DTMindsetConfigurator.make()
        let controller = DTMindsetViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }

    func playMediaItem(_ contentItemId: Int) {
        AppDelegate.current.launchHandler.showContentItem(contentItemId)
    }

    func showHomeScreen() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.appCoordinator.showApp()
        }
    }

    func showFAQScreen(category: ContentCategory) {
        if let controller = R.storyboard.myQot.myQotSupportDetailsViewController() {
            MyQotSupportDetailsConfigurator.configure(viewController: controller, category: category)
            viewController?.present(controller, animated: true)
        }
    }

    func showCoachMarks() {
        if let controller = R.storyboard.coachMark.coachMarksViewController() {
            let configurator = CoachMarksConfigurator.make()
            configurator(controller)
            viewController?.pushToStart(childViewController: controller)
        }
    }

    func showTBV() {
        if let controller = R.storyboard.myToBeVision.myVisionViewController() {
            MyVisionConfigurator.configure(viewController: controller)
            viewController?.pushToStart(childViewController: controller)
        }
    }
}
