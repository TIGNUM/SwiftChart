//
//  ResultsPrepareRouter.swift
//  QOT
//
//  Created by karmic on 11.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ResultsPrepareRouter: BaseRouter {

    // MARK: - Properties
    private var resultType = ResultType.prepareMyPlans
    private lazy var workerCalendar = WorkerCalendar()
    weak var delegate: CalendarEventSelectionDelegate?

    // MARK: - Init
    init(viewController: ResultsPrepareViewController,
         delegate: CalendarEventSelectionDelegate?,
         resultType: ResultType) {
        super.init(viewController: viewController)
        
        self.delegate = delegate
        self.resultType = resultType
    }

    override func dismiss() {
        if resultType == .prepareDecisionTree {
            dismissChatBotFlow()
        } else {
            super.dismiss()
        }
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
    func didTapDismiss() {
        dismiss()
    }

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

    func didSelectStrategy(_ contentId: Int) {
        presentContent(contentId)
    }

    func presentCalendarEventSelection() {
        let configurator = CalendarEventSelectionConfigurator.make(delegate: delegate)
        let controller = CalendarEventSelectionViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }

    func presentDTEditView(_ viewModel: DTViewModel,
                           question: QDMQuestion?,
                           delegate: ResultsPrepareViewControllerInterface?) {
        let configurator = DTPrepareConfigurator.make(viewModel: viewModel, question: question)
        let controller = DTPrepareViewController(configure: configurator)
        controller.delegate = delegate
        viewController?.present(controller, animated: true)
    }

    func presentEditStrategyView(_ relatedStrategyId: Int,
                                 _ selectedIDs: [Int],
                                 delegate: ChoiceViewControllerDelegate?) {
        let configurator = ChoiceConfigurator.make(selectedIDs, relatedStrategyId)
        let controller = ChoiceViewController(configure: configurator)
        controller.delegate = delegate
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
