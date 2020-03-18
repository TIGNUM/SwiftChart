//
//  ResultsPrepareRouter.swift
//  QOT
//
//  Created by karmic on 11.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ResultsPrepareRouter {

    // MARK: - Properties
    private lazy var workerCalendar = WorkerCalendar()
    private weak var viewController: ResultsPrepareViewController?
    weak var delegate: CalendarEventSelectionDelegate?

    // MARK: - Init
    init(viewController: ResultsPrepareViewController?, delegate: CalendarEventSelectionDelegate?) {
        self.viewController = viewController
        self.delegate = delegate
    }
}

// MARK: - Private
private extension ResultsPrepareRouter {
    func presentCalendarPermission(_ permissionType: AskPermission.Kind) {
         guard let controller = R.storyboard.askPermission().instantiateInitialViewController() as?
             AskPermissionViewController else { return }
         AskPermissionConfigurator.make(viewController: controller, type: permissionType, delegate: self)
         viewController?.present(controller, animated: true, completion: nil)
     }

    func presentCalendarSettings() {
        guard let controller = R.storyboard.myQot.syncedCalendarsViewController() else { return }
        SyncedCalendarsConfigurator.configure(viewController: controller,
                                              isInitialCalendarSelection: true,
                                              delegate: self)
        viewController?.present(controller, animated: true)
    }

    func hasSyncedCalendars() {
        workerCalendar.hasSyncedCalendars { [weak self] (available) in
            guard let strongSelf = self else { return }
            if available == true {
                strongSelf.presentCalendarEventSelection()
            } else {
                strongSelf.presentCalendarSettings()
            }
        }
     }
}

// MARK: - ResultsPrepareRouterInterface
extension ResultsPrepareRouter: ResultsPrepareRouterInterface {
    func presentPlans() {

    }

    func didSelectConnectToCalendar() {
        switch CalendarPermission().authorizationStatus {
        case .notDetermined:
            presentCalendarPermission(.calendar)
        case .denied, .restricted:
            presentCalendarPermission(.calendarOpenSettings)
        default:
            hasSyncedCalendars()
        }
    }

    func presentCalendarEventSelection() {
        let configurator = CalendarEventSelectionConfigurator.make(delegate: delegate)
        let controller = CalendarEventSelectionViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }

    func presentDTEditView(_ viewModel: DTViewModel, question: QDMQuestion?) {
        let configurator = DTPrepareConfigurator.make(viewModel: viewModel, question: question)
        let controller = DTPrepareViewController(configure: configurator)
        controller.delegate = viewController
        viewController?.present(controller, animated: true)
    }

    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func presentContent(_ contentId: Int) {
        AppDelegate.current.launchHandler.showContentCollection(contentId)
    }

    func presentEditStrategyView(_ relatedStrategyId: Int, _ selectedIDs: [Int]) {
        let configurator = ChoiceConfigurator.make(selectedIDs, relatedStrategyId)
        let controller = ChoiceViewController(configure: configurator)
        controller.delegate = viewController
        viewController?.present(controller, animated: true)
    }
}

// MARK: - AskPermissionDelegate
extension ResultsPrepareRouter: AskPermissionDelegate {
    func didFinishAskingForPermission(type: AskPermission.Kind, granted: Bool) {
        if granted {
            presentCalendarSettings()
        }
    }
}

// MARK: - SyncedCalendarsDelegate
extension ResultsPrepareRouter: SyncedCalendarsDelegate {
    func didFinishSyncingCalendars(hasSyncedCalendars: Bool, qdmEvents: [QDMUserCalendarEvent]) {
        if hasSyncedCalendars {
            presentCalendarEventSelection()
        }
    }
}
