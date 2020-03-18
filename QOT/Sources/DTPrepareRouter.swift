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

    func didUpdatePrepareResults() {
        dismissResultView()
    }

    func dismissResultView() {
        viewController?.dismiss(animated: true)
    }

    func loadShortTBVGenerator(introKey: String, delegate: DTShortTBVDelegate?, completion: (() -> Void)?) {
        let configurator = DTShortTBVConfigurator.make(introKey: introKey, delegate: delegate)
        let controller = DTShortTBVViewController(configure: configurator)
        viewController?.present(controller, animated: true, completion: completion)
    }

    func presentPrepareResults(_ contentId: Int) {
//        let configurator = ResultsPrepareConfigurator.configurate(contentId)
//        let controller = ResultsViewController(configure: configurator)
//        viewController?.present(controller, animated: true)
    }

    func presentPrepareResults(_ preparation: QDMUserPreparation?) {
        let configurator = ResultsPrepareConfigurator.make(preparation, resultType: .prepareDecisionTree)
        let controller = ResultsPrepareViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }

    func presentCalendarPermission(_ permissionType: AskPermission.Kind) {
        guard let controller = R.storyboard.askPermission().instantiateInitialViewController() as?
            AskPermissionViewController else { return }
        AskPermissionConfigurator.make(viewController: controller, type: permissionType, delegate: prepareViewController)
        viewController?.present(controller, animated: true, completion: nil)
    }

    func presentCalendarSettings() {
//        guard let controller = R.storyboard.myQot.syncedCalendarsViewController() else { return }
//        SyncedCalendarsConfigurator.configure(viewController: controller,
//                                              isInitialCalendarSelection: true,
//                                              delegate: prepareViewController)
//        viewController?.present(controller, animated: true)
    }

    func presentEditEventController(_ calendarToggleIdentifiers: [String]?) {
        let eventEditVC = EKEventEditViewController()
        eventEditVC.eventStore = EKEventStore.shared
        eventEditVC.editViewDelegate = prepareViewController
        eventEditVC.event = EKEvent(eventStore: EKEventStore.shared)
        eventEditVC.event?.calendar = EKEventStore.shared.calendars(for: .event).filter { // mutable & not subscribed
            calendarToggleIdentifiers?.contains($0.toggleIdentifier) == true &&
                $0.allowsContentModifications &&
                $0.isSubscribed == false
        }.first ?? EKEventStore.shared.calendars(for: .event).filter { // mutable
            calendarToggleIdentifiers?.contains($0.toggleIdentifier) == true && $0.allowsContentModifications
        }.first ?? EKEventStore.shared.calendars(for: .event).first // don't care
        viewController?.present(eventEditVC, animated: true)
    }
}
