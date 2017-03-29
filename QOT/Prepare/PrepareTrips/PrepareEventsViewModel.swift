//
//  PrepareTripsViewModel.swift
//  QOT
//
//  Created by karmic on 28/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class PrepareEventsViewModel {
    private let sections: [PrepareEventsSection] = mockSections()

    let updates = PublishSubject<CollectionUpdate, NoError>()

    var sectionCount: Int {
        return sections.count
    }

    func title(section: Int) -> String {
        return sections[section].title
    }

    func itemCount(section: Int) -> Int {
        return sections[section].items.count
    }

    func item(at indexPath: IndexPath) -> PrepareEventsItem {
        return sections[indexPath.section].items[indexPath.row]
    }
}

enum PrepareEventsItem {
    case event(localID: String, title: String, subtitle: String)
    case addEvent(title: String)
    case addReminder(title: String)
    case saveToPDF(title: String)
}

private struct PrepareEventsSection {
    let title: String
    let items: [PrepareEventsItem]
}

private func mockSections() -> [PrepareEventsSection] {
    let eventTitle = "FLIGHT TO BASEL NOVARTIS"
    let eventSubtitle = "12 Sep. // 18 Sep."
    let event = PrepareEventsItem.event(localID: UUID().uuidString, title: eventTitle, subtitle: eventSubtitle)
    var events = [PrepareEventsItem](repeating: event, count: 4)
    events.append(.addEvent(title: "Add new trip"))

    let addReminder = PrepareEventsItem.addReminder(title: "Remind me this preparation")
    let savePDF = PrepareEventsItem.saveToPDF(title: "Save this preparation as PDF")

    return [
        PrepareEventsSection(title: "UPCOMING TRIPS", items: events),
        PrepareEventsSection(title: "ADD TO REMINDER", items: [addReminder]),
        PrepareEventsSection(title: "SAVE IT AS PDF", items: [savePDF])
    ]
}
