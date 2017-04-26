//
//  LearnStrategyViewModel.swift
//  QOT
//
//  Created by karmic on 29/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class LearnStrategyViewModel {

    private let sections = mockLearnStrategyItems()
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var sectionCount: Int {
        return sections.count
    }

    func numberOfItemsInSection(in section: Int) -> Int {
        return items(in: section).count
    }

    func item(at indexPath: IndexPath) -> LearnStrategyItem {
        return items(in: indexPath.section)[indexPath.row]
    }

    private func items(in section: Int) -> [LearnStrategyItem] {
        switch sections[section] {
        case .strategyItems(let strategyItems): return strategyItems
        case .readMoreItems(let readMoreItems): return readMoreItems
        }
    }
}

private enum LearnStrategySection {
    case strategyItems([LearnStrategyItem])
    case readMoreItems([LearnStrategyItem])
}

enum LearnStrategyItem {
    case header(localID: String, title: NSAttributedString, subtitle: NSAttributedString)
    case text(localID: String, text: NSAttributedString)
    case media(localID: String, placeholderURL: URL, description: NSAttributedString)
    case article(localID: String, title: NSAttributedString, subtitle: NSAttributedString)
}

private func mockLearnStrategyItems() -> [LearnStrategySection] {
    return [
        .strategyItems(mockStrategyItems()),
        .readMoreItems(mockReadMore())
    ]
}

private func mockStrategyItems() -> [LearnStrategyItem] {
    return [
        .header(
            localID: UUID().uuidString,
            title: AttributedString.Learn.headerTitle(string: "OPTIMAL PERFORMANCE STATE"),
            subtitle: AttributedString.Learn.headerSubtitle(string: "Performance Mindset")
        ),

        .text(
            localID: UUID().uuidString,
            text: AttributedString.Learn.text(string: "Sustainable High Performance is about bringing your best to those critical events that matter most to you. In each of these events, the demands on you and your mindset will be different. In order to optimize your effectiveness you will have to be in your optimal performance state.")
        ),

        .media(
            localID: UUID().uuidString,
            placeholderURL: URL(string:"https://example.com")!,
            description: AttributedString.Learn.mediaDescription(string: "How to create your optimal performance state (2:26)")
        ),

        .text(
            localID: UUID().uuidString,
            text: AttributedString.Learn.text(string: "In one meeting you may need to be sharp, critical, and driving. In the next meeting you may need to be calm, open, and assessing. When you walk into your house at the end of the day your best emotional state may be serene, loving, and appreciative. Each of these emotional states are different and being caught in the wrong emotional performance state can greatly diminish your chances for success and impact. Through awareness and setting clear intentions you can determine the proper emotional performance state for each event. You can think of this perfect state as a number from 1 to 10 on a slider. Perhaps a 10 would be highly aggressive and assertive and a 1 would be totally passive and assessing. A sales presentation may require you to be a 7.5 to be at your best while a family dinner may require you be at a 4.0. The key is to recognize that every situation is unique and all of us are unique. Some people give their best presentations at a 5 while others are their best at a 9. Once you are clear on where your optimal performance state should be for you and this event the next step is to create it. Two great tools that work for this are ratio breathing and visualization. Ratio breathing refers to the ration of inhalation to exhalation. Breathing in on a count of 4 and exhaling on a count of 4 will represent a balanced middle of the road scale. Increasing your inhalation and shortening your exhalation will move you towards the higher more assertive numbers. Decreasing your inhalation and increasing your exhalation will create more relaxation and serenity. Visualizing yourself in your optimal performance state (connected with the appropriate breathing) is a great way to train your brain to quickly recognize and accept this state. When you do this your brain not only knows what you want, it automatically and unconsciously creates success."
            )
        )
    ]
}

private func mockReadMore() -> [LearnStrategyItem] {
    return [
        .header(
            localID: UUID().uuidString,
            title: AttributedString.Learn.headerTitle(string: "Read More"),
            subtitle: AttributedString.Learn.headerSubtitle(string: "34 Articles")
        ),

        .article(
            localID: UUID().uuidString,
            title: AttributedString.Learn.articleTitle(string: "Leverage Stress Benefits"),
            subtitle: AttributedString.Learn.articleSubtitle(string: "5 Min to read")
        ),

        .article(
            localID: UUID().uuidString,
            title: AttributedString.Learn.articleTitle(string: "Off to see the wizard"),
            subtitle: AttributedString.Learn.articleSubtitle(string: "5:45 to listen")
        ),

        .article(
            localID: UUID().uuidString,
            title: AttributedString.Learn.articleTitle(string: "The small change that do"),
            subtitle: AttributedString.Learn.articleSubtitle(string: "4 min read")
        )
    ]
}
