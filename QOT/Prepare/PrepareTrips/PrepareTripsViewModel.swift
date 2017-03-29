//
//  PrepareTripsViewModel.swift
//  QOT
//
//  Created by karmic on 28/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class PrepareTripsViewModel {
    private var items: PrepareTrip = mockTripItems()
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var calendarItemCount: Int {
        return items.calendar.items.count
    }

    func calendarItem(at index: Int) -> PrepareTripCalendarItem {
        return items.calendar.items[index]
    }
}

protocol PrepareTrip {
    var calendar: (prepareItem: PrepareTripItem, items: [PrepareTripCalendarItem]) { get }
    var reminderItem: PrepareTripItem { get }
    var pdfItem: PrepareTripItem { get }
}

protocol PrepareTripCalendarItem {
    var localID: String { get }
    var title: String { get }
    var startDate: Date { get }
    var endDate: Date { get }
}

protocol PrepareTripItem {
    var title: String { get }
    var buttonTitle: String { get }
}

struct MockPrepareTripCalendarItem: PrepareTripCalendarItem {
    let localID: String
    let title: String
    let startDate: Date
    let endDate: Date
}

struct MockPrepareTrip: PrepareTrip {
    let calendar: (prepareItem: PrepareTripItem, items: [PrepareTripCalendarItem])
    let reminderItem: PrepareTripItem
    let pdfItem: PrepareTripItem
}

struct MockPrepareTripStoreItem: PrepareTripItem {
    let title: String
    let buttonTitle: String
}

private func mockTripItems() -> PrepareTrip {
    return MockPrepareTrip(
        calendar: (prepareItem: MockPrepareTripStoreItem(title: "Upcoming Trips", buttonTitle: "Add new Trip"), items: mockTripCalendarItems()),
        reminderItem: MockPrepareTripStoreItem(title: "Add to Reminder", buttonTitle: "Remind me this preparation"),
        pdfItem: MockPrepareTripStoreItem(title: "Save it as PDF", buttonTitle: "Save this preparation as PDF")
    )
}

private func mockTripCalendarItems() -> [PrepareTripCalendarItem] {
    var items: [PrepareTripCalendarItem] = []
    for _ in 1...4 {
        items.append(MockPrepareTripCalendarItem(
            localID: UUID().uuidString,
            title: "FLIGHT TO BASEL Novartis",
            startDate: Date(),
            endDate: Date())
        )
    }

    return items
}
