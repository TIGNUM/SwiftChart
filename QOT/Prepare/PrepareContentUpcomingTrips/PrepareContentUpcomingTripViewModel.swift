//
//  PrepareContentUpcomingTripViewModel.swift
//  QOT
//
//  Created by karmic on 28/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import EventKit

final class PrepareContentUpcomingTripViewModel {
    private var items: [UpcomingTripItem] = mockUpcomingTripItems()

    var itemCount: Int {
        return items.count
    }

    func item(at index: Int) -> UpcomingTripItem {
        return items[index]
    }
}

enum UpcomingTripItem {
    case title(localID: String, text: String)
    case upcomingTripsInCalendar([UpcomingTripCalendarItem])
    case upcomingTripsInReminder([UpcomingTripReminderItem])
    case upcomingTripsPDFItem([UpcomingTripPDFItem])
}

enum UpcomingTripPDFItem {
    case trippdfItem(localID: String, title: String, pdfURL: URL)
}

enum UpcomingTripReminderItem {
    case tripReminderItem(localID: String, reminderItem: EKReminder)
}

enum UpcomingTripCalendarItem {
    case tripCalendarItem(localID: String, calendarEvent: CalendarEvent)
}

private func mockUpcomingTripItems() -> [UpcomingTripItem] {
    return [
        .title(localID: UUID().uuidString, text: "UPCOMING TRIPS"),
        .upcomingTripsInCalendar(mockUpcomingTripCalendarItems()),
        .upcomingTripsInReminder(mockUpcomingTripReminderItems()),
        .upcomingTripsPDFItem(mockUpcomingTripPDFItems())
    ]
}

private func mockUpcomingTripCalendarItems() -> [UpcomingTripCalendarItem] {
    let eventStore = EKEventStore()
    let calendar = EKCalendar(for: .event, eventStore: eventStore)
    var items: [UpcomingTripCalendarItem] = []
    for _ in 1...10 {
        if let calendarForEvent = eventStore.calendar(withIdentifier: calendar.calendarIdentifier) {
            let newEvent = EKEvent(eventStore: eventStore)
            newEvent.calendar = calendarForEvent
            newEvent.title = "FLIGHT TO BASEL Novartis"
            newEvent.startDate = Date()
            newEvent.endDate = Date()
            items.append(.tripCalendarItem(localID: UUID().uuidString, calendarEvent: CalendarEvent(event: newEvent)))
        }
    }

    return items
}

private func mockUpcomingTripReminderItems() -> [UpcomingTripReminderItem] {
    let eventStore = EKEventStore()
    let calendar = EKCalendar(for: .reminder, eventStore: eventStore)
    var items: [UpcomingTripReminderItem] = []
    for _ in 1...10 {
        if let calendarForEvent = eventStore.calendar(withIdentifier: calendar.calendarIdentifier) {
            let newReminder = EKReminder(eventStore: eventStore)
            newReminder.calendar = calendarForEvent
            newReminder.title = "Remind me this preparation"
            items.append(.tripReminderItem(localID: UUID().uuidString, reminderItem: newReminder))
        }
    }

    return items
}

private func mockUpcomingTripPDFItems() -> [UpcomingTripPDFItem] {
    var items: [UpcomingTripPDFItem] = []
    for _ in 1...10 {
        items.append(.trippdfItem(localID: UUID().uuidString, title: "Save this preparation as PDF", pdfURL: URL(string:"https://example.com")!))
    }

    return items
}
