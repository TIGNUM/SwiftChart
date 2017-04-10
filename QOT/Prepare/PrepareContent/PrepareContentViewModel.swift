//
//  PrepareContentViewModel.swift
//  QOT
//
//  Created by karmic on 27/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class PrepareContentViewModel {
    private var items: [PrepareContentItem] = mockContentItems()

    var itemCount: Int {
        return items.count
    }

    func item(at index: Int) -> PrepareContentItem {
        return items[index]
    }

    func didTapHeader(localID: String) {
        print("tapped header")
    }
}

enum PrepareContentItem {
    case title(localID: String, text: String)
    case text(localID: String, text: String)
    case video(localID: String, placeholderURL: URL)
    case step(localID: String, index: Int, text: String)
    case header(sectionID: String, title: String, open: Bool)
    case footer(sectionID: String?)
}

private func mockContentItems() -> [PrepareContentItem] {
    var items: [PrepareContentItem] = []

    items.append(.title(localID: UUID().uuidString, text: "SUSTAINABLE HIGH PERFORMANCE TRAVEL"))
    items.append(.header(sectionID: UUID().uuidString, title: "PRE TRAVEL", open: true))
    items.append(contentsOf: mockContentStepItems())
    items.append(.footer(sectionID: UUID().uuidString))
    items.append(.header(sectionID: UUID().uuidString, title: "ON TRAVEL", open: false))
    items.append(.header(sectionID: UUID().uuidString, title: "AFTER TRAVEL", open: false))
    items.append(.text(localID: UUID().uuidString, text: "Sustainable High Performance Travel is the ability to arrive at a business event fully energized, focused, creative, resilient, healthy, and with minimal effects from Jet Lag. Jet Lag is a compilation of symptoms caused by traveling across time zones. Recent research has revealed that every organ system in the body has its own time clock which resynchronizes to travel at its own speed. This helps explain why everyone experiences Jet Lag differently."))
    items.append(.video(localID: UUID().uuidString, placeholderURL: URL(string:"https://example.com")!))
    items.append(.text(localID: UUID().uuidString, text: "There are many remedies and strategies out there (especially on the internet) but many of them are unproven, impractical, or unsafe. The following suggestions are the best strategies that have worked for our TIGNUM clients who travel millions of kilometers/miles every year. These suggestions follow our totally integrated approach (Mindset, Nutrition, Movement, and Recovery) and address all of the major organ systems."))
    items.append(.text(localID: UUID().uuidString, text: "At TIGNUM we believe in a new level of preparation (this requires planning) and therefore, we look at Sustainable High Performance Travel from a pre-travel, during travel, and post-travel perspective."))
    items.append(.footer(sectionID: nil))

    return items
}

private func mockContentStepItems() -> [PrepareContentItem] {
    var items: [PrepareContentItem] = []
    for i in 1...10 {
        items.append(.step(localID: UUID().uuidString, index: i, text: "Whenever possible, select hotels that support quality rest, daily Movement, and high performance meal choices."))
    }
    items.insert(.video(localID: UUID().uuidString, placeholderURL: URL(string:"https://example.com")!), at: 4)

    return items
}
