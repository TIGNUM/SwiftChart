//
//  EKEvent+Convenience.swift
//  QOT
//
//  Created by karmic on 17.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import EventKit
import qot_dal

protocol EKEventEditable {
    func addPreparationLink(preparationID: String?, permissionsManager: PermissionsManager)
}

extension EKEvent: EKEventEditable {
    func addPreparationLink(preparationID: String?, permissionsManager: PermissionsManager) {
        guard let localID = preparationID else { return }
        permissionsManager.askPermission(for: [.calendar], completion: { [weak self] status in
            guard let status = status[.calendar], let strongSelf = self else { return }
            switch status {
            case .granted:
                var tempNotes = strongSelf.notes ?? ""
                guard let preparationLink = URLScheme.preparationURL(withID: localID) else { return }
                tempNotes += "\n\n" + preparationLink
                log("preparationLink: \(preparationLink)")
                strongSelf.notes = tempNotes
                do {
                    try EKEventStore.shared.save(strongSelf, span: .thisEvent, commit: true)
                } catch let error {
                    log("createPreparation - eventStore.save.error: \(error.localizedDescription)", level: .error)
                    return
                }
            case .later:
                permissionsManager.updateAskStatus(.canAsk, for: .calendar)
            default:
                break
            }
        })
    }

    func addPreparationLink(preparationID: String?) {
        guard let localID = preparationID else { return }
        var tempNotes = notes ?? ""
        guard let preparationLink = URLScheme.preparationURL(withID: localID) else { return }
        tempNotes += "\n\n" + preparationLink
        log("preparationLink: \(preparationLink)")
        notes = tempNotes
        do {
            try EKEventStore.shared.save(self, span: .thisEvent, commit: true)
        } catch let error {
            log("createPreparation - eventStore.save.error: \(error.localizedDescription)", level: .error)
            return
        }
    }
}

extension EKEventStore {

    static var shared = EKEventStore()

    func event(with qdmCalendarEvent: QDMUserCalendarEvent) -> EKEvent? {
        guard
            let startDate = qdmCalendarEvent.startDate,
            let endDate = qdmCalendarEvent.endDate else { return nil }
        let externalIdentifier = qdmCalendarEvent.calendarItemExternalId?.components(separatedBy: "[//]").first
        return getEvent(startDate: startDate, endDate: endDate, identifier: externalIdentifier)
    }

    func getEvent(startDate: Date, endDate: Date, identifier: String?) -> EKEvent? {
        let predicate = predicateForEvents(withStart: startDate - TimeInterval(days: 1),
                                           end: endDate + TimeInterval(days: 1),
                                           calendars: nil)
        var event: EKEvent?
        enumerateEvents(matching: predicate) { (ekEvent, stop) in
            /*
             @warning do not use `calendarEvent.matches(event: EKEvent) -> Bool`
             enumerateEvents(...) runs this block on the main thread, which can cause issues the CalendarEvent is from a
             Realm initialised on another thread (e.g. background thread from sync)
             */
            if let tmpIdentifier = identifier, tmpIdentifier == ekEvent.calendarItemExternalIdentifier &&
                startDate == ekEvent.startDate {
                event = ekEvent
                stop.pointee = true
            }
        }
        return event
    }

}
