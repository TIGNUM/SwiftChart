//
//  DTPrepareRouter.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import qot_dal

final class DTPrepareRouter: DTRouter {

    // MARK: - Properties
    weak var prepareViewController: DTPrepareViewController?
}

// MARK: - DTPrepareRouterInterface
extension DTPrepareRouter: DTPrepareRouterInterface {
    func loadShortTBVGenerator(introKey: String, delegate: DTShortTBVDelegate?, completion: (() -> Void)?) {
        let configurator = DTShortTBVConfigurator.make(introKey: introKey, delegate: delegate)
        let controller = DTShortTBVViewController(configure: configurator)
        viewController?.present(controller, animated: true, completion: completion)
    }

    func presentPrepareResults(_ contentId: Int) {
        let configurator = PrepareResultsConfigurator.configurate(contentId)
        let controller = PrepareResultsViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }

    func presentPrepareResults(_ preparation: QDMUserPreparation?, canDelete: Bool) {
        let configurator = PrepareResultsConfigurator.make(preparation, canDelete: canDelete)
        let controller = PrepareResultsViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }

    func presentCalendarPermission(_ permissionType: AskPermission.Kind) {
        guard let controller = R.storyboard.askPermission().instantiateInitialViewController() as?
            AskPermissionViewController else { return }
        AskPermissionConfigurator.make(viewController: controller, type: permissionType, delegate: prepareViewController)
        viewController?.present(controller, animated: true, completion: nil)
    }

    func presentEditEventController() {
        let eventEditVC = EKEventEditViewController()
        eventEditVC.eventStore = EKEventStore.shared
        eventEditVC.editViewDelegate = prepareViewController
        viewController?.present(eventEditVC, animated: true)
    }
}
