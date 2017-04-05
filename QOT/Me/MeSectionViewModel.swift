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

    let items = mockMyDataItems
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        return items.count
    }

    func item(at indexPath: IndexPath) -> MyDataItem {
        return items[indexPath.row]
    }

    func distance(at indexPath: IndexPath) -> CGFloat {
        switch items[indexPath.row] {
        case .dataPoint(_, _, let distance, _, _): return distance
        default: return 0
        }
    }

    func angle(at indexPath: IndexPath) -> CGFloat {
        switch items[indexPath.row] {
        case .dataPoint(_, _, _, let angle, _): return angle
        default: return 0
        }
    }
}

enum MyDataItem {
    case image(localID: String, placeholderURL: URL)
    case dataPoint(localID: String, title: String, distance: CGFloat, angle: CGFloat, category: Category)

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
            distance: randomNumber,
            angle: randomNumber,
            category: .load
        ),

        .dataPoint(
            localID: UUID().uuidString,
            title: "Travel",
            distance: randomNumber,
            angle: randomNumber,
            category: .load
        ),

        .dataPoint(
            localID: UUID().uuidString,
            title: "Intensity",
            distance: randomNumber,
            angle: randomNumber,
            category: .load
        ),

        .dataPoint(
            localID: UUID().uuidString,
            title: "Peek Performance",
            distance: randomNumber,
            angle: randomNumber,
            category: .load
        ),

        .dataPoint(
            localID: UUID().uuidString,
            title: "Sleep",
            distance: randomNumber,
            angle: randomNumber,
            category: .brainBody
        ),

        .dataPoint(
            localID: UUID().uuidString,
            title: "Activity",
            distance: randomNumber,
            angle: randomNumber,
            category: .brainBody
        ),

        .dataPoint(
            localID: UUID().uuidString,
            title: "Meeting",
            distance: randomNumber,
            angle: randomNumber,
            category: .load
        ),

        .dataPoint(
            localID: UUID().uuidString,
            title: "Travel",
            distance: randomNumber,
            angle: randomNumber,
            category: .load
        ),

        .dataPoint(
            localID: UUID().uuidString,
            title: "Intensity",
            distance: randomNumber,
            angle: randomNumber,
            category: .load
        ),

        .dataPoint(
            localID: UUID().uuidString,
            title: "Peek Performance",
            distance: randomNumber,
            angle: randomNumber,
            category: .load
        ),

        .dataPoint(
            localID: UUID().uuidString,
            title: "Sleep",
            distance: randomNumber,
            angle: randomNumber,
            category: .brainBody
        ),

        .dataPoint(
            localID: UUID().uuidString,
            title: "Activity",
            distance: randomNumber,
            angle: randomNumber,
            category: .brainBody
        )
    ]
}
