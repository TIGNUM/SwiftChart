//
//  PrepareContentTravelViewModel.swift
//  QOT
//
//  Created by karmic on 27/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class PrepareContentTravelViewModel {
    private var items: [PrepareContentTravelItem] = mockContentItems()

    var itemCount: Int {
        return items.count
    }

    func item(at index: Int) -> PrepareContentTravelItem {
        return items[index]
    }
}

enum PrepareContentTravelItem {
    case title(id: String, text: String)
    case text(id: String, text: String)
    case video(id: String, placeholderURL: URL)
    case collection(id: String, title: String, items: [PrepareSubContentTravelItem])
}

enum PrepareSubContentTravelItem {
    case step(id: String, index: Int, text: String)
    case video(id: String, placeholderURL: URL)
}

private func mockContentItems() -> [PrepareContentTravelItem] {
    return [
        .title(id: UUID().uuidString, text: "SUSTAINABLE HIGH PERFORMANCE TRAVEL"),

        .collection(id: UUID().uuidString, title: "PRE TRAVEL", items: mockContentSubItems()),

        .collection(id: UUID().uuidString, title: "ON TRAVEL", items: mockContentSubItems()),

        .collection(id: UUID().uuidString, title: "AFTER TRAVEL", items: mockContentSubItems()),

        .video(id: UUID().uuidString, placeholderURL: URL(string:"https://example.com")!),

        .text(id: UUID().uuidString, text: "Sustainable High Performance Travel is the ability to arrive at a business event fully energized, focused, creative, resilient, healthy, and with minimal effects from Jet Lag. Jet Lag is a compilation of symptoms caused by traveling across time zones. Recent research has revealed that every organ system in the body has its own time clock which resynchronizes to travel at its own speed. This helps explain why everyone experiences Jet Lag differently."),

        .text(id: UUID().uuidString, text: "There are many remedies and strategies out there (especially on the internet) but many of them are unproven, impractical, or unsafe. The following suggestions are the best strategies that have worked for our TIGNUM clients who travel millions of kilometers/miles every year. These suggestions follow our totally integrated approach (Mindset, Nutrition, Movement, and Recovery) and address all of the major organ systems."),

        .text(id: UUID().uuidString, text: "At TIGNUM we believe in a new level of preparation (this requires planning) and therefore, we look at Sustainable High Performance Travel from a pre-travel, during travel, and post-travel perspective.")
    ]
}

private func mockContentSubItems() -> [PrepareSubContentTravelItem] {
    var items: [PrepareSubContentTravelItem] = []
    for i in 1...10 {
        items.append(.step(id: UUID().uuidString, index: i, text: "Whenever possible, select hotels that support quality rest, daily Movement, and high performance meal choices."))
    }
    items.insert(.video(id: UUID().uuidString, placeholderURL: URL(string:"https://example.com")!), at: 4)
    
    return items
}
