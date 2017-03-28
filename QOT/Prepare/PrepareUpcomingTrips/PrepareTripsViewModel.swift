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
    private var items: PrepareTripSections = mockTripSections()
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var tripCalendarItemCount: Int {
        return items.calendarSection.items.count
    }

    func tripCalendarItem(at index: Int) -> PrepareTripCalendarItem {
        return items.calendarSection.items[index]
    }
}

protocol PrepareTripSections {
    var calendarSection: PrepareTripCalendarSection { get }
    var reminderSection: PrepareTripSection { get }
    var pdfSection: PrepareTripSection { get }
}

protocol PrepareTripCalendarSection {
    var sectionTitle: String { get }
    var items: [PrepareTripCalendarItem] { get }
    var buttonTitle: String { get }
}

protocol PrepareTripSection {
    var sectionTitle: String { get }
    var buttonTitle: String { get }
}

protocol PrepareTripCalendarItem {
    var localID: String { get }
    var title: String { get }
    var startDate: Date { get }
    var endDate: Date { get }
}

struct MockPrepareTripCalendarSection: PrepareTripCalendarSection {
    let sectionTitle: String
    let items: [PrepareTripCalendarItem]
    let buttonTitle: String
}

struct MockPrepareTripCalendarItem: PrepareTripCalendarItem {
    let localID: String
    let title: String
    let startDate: Date
    let endDate: Date
}

struct MockPrepareTripSection: PrepareTripSection {
    let sectionTitle: String
    let buttonTitle: String
}

struct MockPrepareTripSections: PrepareTripSections {
    let calendarSection: PrepareTripCalendarSection
    let reminderSection: PrepareTripSection
    let pdfSection: PrepareTripSection
}

private func mockTripSections() -> PrepareTripSections {
    let calendarSection = MockPrepareTripCalendarSection(sectionTitle: "Upcoming Trips", items: mockTripCalendarItems(), buttonTitle: "Add new Trip")
    let reminderSection = MockPrepareTripSection(sectionTitle: "Add to Reminder", buttonTitle: "Remind me this preparation")
    let pdfSection = MockPrepareTripSection(sectionTitle: "Save it as PDF", buttonTitle: "Save this preparation as PDF")

    return MockPrepareTripSections(
        calendarSection: calendarSection,
        reminderSection: reminderSection,
        pdfSection: pdfSection
    )
}

private func mockTripCalendarItems() -> [PrepareTripCalendarItem] {
    var items: [PrepareTripCalendarItem] = []
    for _ in 1...4 {
        items.append(MockPrepareTripCalendarItem(
            localID: UUID().uuidString,
            title: "Remind me this preparation",
            startDate: Date(),
            endDate: Date())
        )
    }

    return items
}
