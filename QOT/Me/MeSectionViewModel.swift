//
//  MeSectionViewModel.swift
//  QOT
//
//  Created by karmic on 04.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class MeSectionViewModel {

    // MARK: - Properties

    private let items = mockMyDataItems
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        return items.count
    }

    func item(at indexPath: IndexPath) -> MyDataItem {
        return items[indexPath.row]
    }
}

enum MyDataItem {
    case image(localID: String, placeholderURL: URL)
    case dataPoint(localID: String, title: String, distance: Float, angle: Float, category: Category)

    enum Category {
        case load
        case brainBody
    }
}

private var mockMyDataItems: [MyDataItem] {
    return [
        .image(
            localID: UUID().uuidString, placeholderURL: URL(string:"https://example.com")!
        ),

        .dataPoint(
            localID: UUID().uuidString,
            title: "Meeting",
            distance: 0.9,
            angle: 0.45,
            category: .load
        ),

        .dataPoint(
            localID: UUID().uuidString,
            title: "Travel",
            distance: 0.8,
            angle: 0.6,
            category: .load
        ),

        .dataPoint(
            localID: UUID().uuidString,
            title: "Intensity",
            distance: 0.7,
            angle: 0.5,
            category: .load
        ),

        .dataPoint(
            localID: UUID().uuidString,
            title: "Peek Performance",
            distance: 0.6,
            angle: 0.8,
            category: .load
        ),

        .dataPoint(
            localID: UUID().uuidString,
            title: "Sleep",
            distance: 0.5,
            angle: 0.3,
            category: .brainBody
        ),

        .dataPoint(
            localID: UUID().uuidString,
            title: "Activity",
            distance: 0.4,
            angle: 0.9,
            category: .brainBody
        )
    ]
}
