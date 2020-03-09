//
//  CalendarEventSelectionInteractor.swift
//  QOT
//
//  Created by karmic on 06.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class CalendarEventSelectionInteractor {

    // MARK: - Properties
    private lazy var worker = CalendarEventSelectionWorker()
    private lazy var calendarWorker = WorkerCalendar()
    private let presenter: CalendarEventSelectionPresenterInterface!
    private var qdmEvents: [QDMUserCalendarEvent] = []
    private var events: [CalendarEvent] = []
    private var calendarSettings: [QDMUserCalendarSetting] = []

    // MARK: - Init
    init(presenter: CalendarEventSelectionPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        calendarWorker.getCalendarSettings { [weak self] (settings) in
            self?.calendarSettings = settings
        }
        calendarWorker.getCalendarEvents { [weak self] (events) in
            self?.setUserCalendarEvents(events)
            self?.convertEvents(events)
            self?.presenter.setupView()
        }
    }
}

// MARK: - CalendarEventSelectionInteractorInterface
extension CalendarEventSelectionInteractor: CalendarEventSelectionInteractorInterface {
    var rowCount: Int {
        return qdmEvents.count
    }

    var rightBarItemTitle: String {
        return AppTextService.get(.addNewEvent)
    }

    func event(at row: Int) -> CalendarEvent? {
        return events.at(index: row)
    }

    func didSelectPreparationEvent(at row: Int) {

    }

    func getCalendarIds() -> [String] {
        let calendarIds = calendarSettings.filter { $0.syncEnabled == true }.compactMap { $0.calendarId }
        return calendarIds
    }
}

// MARK: - Private
private extension CalendarEventSelectionInteractor {
    func convertEvents(_ qdmEvents: [QDMUserCalendarEvent]) {
        qdmEvents.forEach { (qdmEvent) in
            if let remoteId = qdmEvent.remoteID,
                let title = qdmEvent.title,
                let date = Prepare.dateString(for: qdmEvent.startDate) {
                events.append(CalendarEvent(remoteId: remoteId,
                                            title: title,
                                            dateString: date))
            }
        }
    }

    func setUserCalendarEvents(_ events: [QDMUserCalendarEvent]) {
        self.qdmEvents.removeAll()
        self.qdmEvents = events.sorted(by: { (lhs, rhs) -> Bool in
            return lhs.startDate?.compare(rhs.startDate ?? Date()) == .orderedAscending
        }).unique
    }
}
