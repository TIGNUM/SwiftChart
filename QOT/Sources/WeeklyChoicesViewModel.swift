//
//  WeeklyChoicesViewModel.swift
//  QOT
//
//  Created by karmic on 18.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import LoremIpsum

final class WeeklyChoicesViewModel {

    struct WeeklyChoicePage {
        var weekStart: Date
        var choice1: WeeklyChoice?
        var choice2: WeeklyChoice?
        var choice3: WeeklyChoice?
        var choice4: WeeklyChoice?
        var choice5: WeeklyChoice?

        init(weekStart: Date, choice1: WeeklyChoice? = nil, choice2: WeeklyChoice? = nil, choice3: WeeklyChoice? = nil, choice4: WeeklyChoice? = nil, choice5: WeeklyChoice? = nil) {
            self.weekStart = weekStart
            self.choice1 = choice1
            self.choice2 = choice2
            self.choice3 = choice3
            self.choice4 = choice4
            self.choice5 = choice5
        }
    }

    // MARK: - Properties

    let itemsPerWeek = 5

    var items: [WeeklyChoicePage] = []
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        return items.count * itemsPerWeek
    }

    func pageDates(forIndex index: Index) -> String {
        let week = index / itemsPerWeek
        let weekChoices = items[week]
        let weekEnd = weekChoices.weekStart + TimeInterval(6 * 24 * 3600)

        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMd")
        dateFormatter.locale = Locale.current
        
        return "\(dateFormatter.string(from: weekChoices.weekStart)) // \(dateFormatter.string(from: weekEnd))"
    }

    func choiceNumber(forIndex index: Index) -> String {
        let choiceNumber = index % itemsPerWeek + 1

        return ".0\(choiceNumber) \(R.string.localized.meSectorMyWhyWeeklyChoicesChoice())"
    }

    func item(at index: Index) -> WeeklyChoice? {
        let week = index / itemsPerWeek
        let choiceNumber = index % itemsPerWeek
        let weekChoices = items[week]

        switch choiceNumber {
        case 0:
            return weekChoices.choice1
        case 1:
            return weekChoices.choice2
        case 2:
            return weekChoices.choice3
        case 3:
            return weekChoices.choice4
        case 4:
            return weekChoices.choice5
        default:
            return nil
        }
    }

    // MARK: - Initialisation

    init() {
        weeklyChoices()
    }

    private func weeklyChoices() {

        for index in 0..<52 {
            var weekChoices = WeeklyChoicePage(weekStart: Date() - TimeInterval(index * 7 * 24 * 3600))

            weekChoices.choice1 =  MockWeeklyChoice(
                localID: UUID().uuidString,
                title:  LoremIpsum.title(),
                subTitle: LoremIpsum.title()
            )

            weekChoices.choice2 =  MockWeeklyChoice(
                localID: UUID().uuidString,
                title: LoremIpsum.title(),
                subTitle: LoremIpsum.title()
            )

            weekChoices.choice3 =  MockWeeklyChoice(
                localID: UUID().uuidString,
                title: LoremIpsum.title(),
                subTitle: LoremIpsum.title()
            )

            weekChoices.choice4 = nil

            weekChoices.choice5 =  MockWeeklyChoice(
                localID: UUID().uuidString,
                title: LoremIpsum.title(),
                subTitle: LoremIpsum.title()
            )
            
            items.append(weekChoices)
        }
    }
}
