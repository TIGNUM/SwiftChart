//
//  PrepareContentViewModel.swift
//  QOT
//
//  Created by karmic on 27/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class PrepareContentViewModel {
    private var items: [PrepareContentItemType] = makeMockContentItems()

    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        return items.count
    }

    func item(at index: Int) -> PrepareContentItemType {
        return items[index]
    }

    func didTapHeader(item: PrepareContentItemType) {
        switch item {
        case .header(let sectionID, _, let open):
            headerStates[sectionID] = !open
            items = makeMockContentItems()
            updates.next(.reload)
        default:
            preconditionFailure("item is not a header: \(item)")
        }
    }
}

enum PrepareContentItemType {
    case title(localID: String, text: String)
    case text(localID: String, text: String)
    case video(localID: String, placeholderURL: URL)
    case step(localID: String, index: Int, text: String)
    case header(sectionID: String, title: String, open: Bool)
    case sectionFooter(sectionID: String)
    case tableFooter
}

// MARK: Mock

private let preTravelHeaderID = "pre-travel-id"
private let onTravelHeaderID = "on-travel-id"
private let afterTravelHeaderID = "after-travel-id"

private var headerStates: [String: Bool] = [
    preTravelHeaderID: false,
    onTravelHeaderID: false,
    afterTravelHeaderID: false
]

private func makeMockContentItems() -> [PrepareContentItemType] {
    var items: [PrepareContentItemType] = []

    items.append(.title(localID: UUID().uuidString, text: "SUSTAINABLE HIGH PERFORMANCE TRAVEL"))

    items.append(contentsOf: makeMockSectionItems(sectionID: preTravelHeaderID, title: "PRE TRAVEL"))
    items.append(contentsOf: makeMockSectionItems(sectionID: onTravelHeaderID, title: "ON TRAVEL"))
    items.append(contentsOf: makeMockSectionItems(sectionID: afterTravelHeaderID, title: "AFTER TRAVEL"))

    items.append(.text(localID: UUID().uuidString, text: "Sustainable High Performance Travel is the ability to arrive at a business event fully energized, focused, creative, resilient, healthy, and with minimal effects from Jet Lag. Jet Lag is a compilation of symptoms caused by traveling across time zones. Recent research has revealed that every organ system in the body has its own time clock which resynchronizes to travel at its own speed. This helps explain why everyone experiences Jet Lag differently."))
    items.append(.video(localID: UUID().uuidString, placeholderURL: URL(string:"https://example.com")!))
    items.append(.text(localID: UUID().uuidString, text: "There are many remedies and strategies out there (especially on the internet) but many of them are unproven, impractical, or unsafe. The following suggestions are the best strategies that have worked for our TIGNUM clients who travel millions of kilometers/miles every year. These suggestions follow our totally integrated approach (Mindset, Nutrition, Movement, and Recovery) and address all of the major organ systems."))
    items.append(.text(localID: UUID().uuidString, text: "At TIGNUM we believe in a new level of preparation (this requires planning) and therefore, we look at Sustainable High Performance Travel from a pre-travel, during travel, and post-travel perspective."))
    items.append(.tableFooter)

    return items
}

private func makeMockSectionItems(sectionID: String, title: String) -> [PrepareContentItemType] {
    let open = headerStates[sectionID]!

    var items: [PrepareContentItemType] = [.header(sectionID: sectionID, title: title, open: open)]
    if !open {
        return items
    } else {
        for i in 1...10 {
            items.append(.step(localID: UUID().uuidString, index: i, text: "Whenever possible, select hotels that support quality rest, daily Movement, and high performance meal choices."))
        }
        items.insert(.video(localID: UUID().uuidString, placeholderURL: URL(string:"https://example.com")!), at: 4)
        items.append(.sectionFooter(sectionID: UUID().uuidString))
        return items
    }
}
