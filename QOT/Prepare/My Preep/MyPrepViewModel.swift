//
//  MyPrepViewModel.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class MyPrepViewModel {
    private let items = mockMyPrepItems()
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        return items.count
    }

    func item(at index: Index) -> MyPrepItem {
        return items[index]
    }
}

protocol MyPrepItem {
    var header: String { get }
    var footer: String { get }
    var text: String { get }
    var totalPreparationCount: Int { get }
    var finishedPreparationCount: Int { get }
}

struct MockMyPrepItem: MyPrepItem {
    let header: String
    let footer: String
    let text: String
    let totalPreparationCount: Int
    let finishedPreparationCount: Int
}

private func mockMyPrepItems() -> [MyPrepItem] {
    return [
        MockMyPrepItem(
            header: "High performance travel",
            footer: "Time to the event 3:25",
            text: "Flight to Basel for Novartis",
            totalPreparationCount: 58,
            finishedPreparationCount: 7
        ),

        MockMyPrepItem(
            header: "High performance travel",
            footer: "Time to the event 3:25",
            text: "Flight to Basel for Novartis",
            totalPreparationCount: 58,
            finishedPreparationCount: 7
        ),

        MockMyPrepItem(
            header: "High performance travel",
            footer: "Time to the event 3:25",
            text: "Flight to Basel for Novartis",
            totalPreparationCount: 58,
            finishedPreparationCount: 7
        ),

        MockMyPrepItem(
            header: "High performance travel",
            footer: "Time to the event 3:25",
            text: "Flight to Basel for Novartis",
            totalPreparationCount: 58,
            finishedPreparationCount: 7
        ),

        MockMyPrepItem(
            header: "High performance travel",
            footer: "Time to the event 3:25",
            text: "Flight to Basel for Novartis",
            totalPreparationCount: 58,
            finishedPreparationCount: 7
        ),

        MockMyPrepItem(
            header: "High performance travel",
            footer: "Time to the event 3:25",
            text: "Flight to Basel for Novartis",
            totalPreparationCount: 58,
            finishedPreparationCount: 7
        )
    ]
}
