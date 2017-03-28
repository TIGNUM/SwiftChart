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
    private var items: [PrepareTripSection] = mockTripSections()
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var tripCalendarItemCount: Int {
        return items.first?.items.count ?? 0
    }

    func tripCalendarItem(at index: Int) -> PrepareTripCalendarItem? {
        return items.first?.items[index]
    }
}

protocol PrepareTripSection {
    var sectionTitle: String { get }
    var buttonTitle: String { get }
    var items: [PrepareTripCalendarItem] { get }
}

protocol PrepareTripCalendarItem {
    var localID: String { get }
    var title: String { get }
    var startDate: Date { get }
    var endDate: Date { get }
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
    let items: [PrepareTripCalendarItem]
}

private func mockTripSections() -> [PrepareTripSection] {
    return [
        MockPrepareTripSection(sectionTitle: "Upcoming Trips", buttonTitle: "Add new Trip", items: mockTripCalendarItems()),
        MockPrepareTripSection(sectionTitle: "Add to Reminder", buttonTitle: "Remind me this preparation", items: []),
        MockPrepareTripSection(sectionTitle: "Save it as PDF", buttonTitle: "Save this preparation as PDF", items: [])
    ]
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
