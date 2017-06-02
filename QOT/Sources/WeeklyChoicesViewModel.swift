//
//  WeeklyChoicesViewModel.swift
//  QOT
//
//  Created by karmic on 18.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class WeeklyChoicesViewModel {

    // MARK: - Properties

    let items = weeklyChoices
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        return items.count
    }

    func item(at index: Index) -> WeeklyChoice {
        return items[index]
    }
}

private var weeklyChoices: [WeeklyChoice] {
    var choices = [WeeklyChoice]()

    for index in 1..<365 {
        let titleIndex = index < 10 ? ("0" + "\(index)") : "\(index)"
        let weeklyChoice =  MockWeeklyChoice(
            localID: UUID().uuidString,
            title: ".\(titleIndex) choice",
            text: "You are having a Lorem ipsum here and"
        )
        choices.append(weeklyChoice)
    }

    return choices
}
