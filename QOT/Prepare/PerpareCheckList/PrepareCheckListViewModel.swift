//
//  PrepareCheckListViewModel.swift
//  QOT
//
//  Created by karmic on 27/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class PrepareCheckListViewModel {
    private var items: [PrepareContentTravelItem] = mockContentTravelItems()
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        return items.count
    }

    func item(at index: Int) -> PrepareContentTravelItem {
        return items[index]
    }
}

enum PrepareContentTravelItem {
    case title(localID: String, text: String)
    case video(localID: String, placeholderURL: URL)
    case collection(localID: String, title: String, items: [PrepareSubContentTravelItem])
}

enum PrepareSubContentTravelItem {
    case step(localID: String, index: Int, text: String, selected: Bool)
    case video(localID: String, placeholderURL: URL)
}

private func mockContentTravelItems() -> [PrepareContentTravelItem] {
    return [
        .title(localID: UUID().uuidString, text: "Trips TO BASEL FOR NOVARIS 2017"),
        .collection(localID: UUID().uuidString, title: "PRE TRAVEL 0/12", items: mockContentTravelSubItems()),
        .collection(localID: UUID().uuidString, title: "ON TRAVEL 0/15", items: mockContentTravelSubItems()),
        .collection(localID: UUID().uuidString, title: "AFTER TRAVEL 0/15", items: mockContentTravelSubItems()),
        .video(localID: UUID().uuidString, placeholderURL: URL(string:"https://example.com")!)
    ]
}

private func mockContentTravelSubItems() -> [PrepareSubContentTravelItem] {
    var items: [PrepareSubContentTravelItem] = []
    for i in 1...10 {
        items.append(.step(localID: UUID().uuidString, index: i, text: "Whenever possible, select hotels that support quality rest, daily Movement, and high performance meal choices.", selected: false))
    }
    items.insert(.video(localID: UUID().uuidString, placeholderURL: URL(string:"https://example.com")!), at: 0)
    
    return items
}
