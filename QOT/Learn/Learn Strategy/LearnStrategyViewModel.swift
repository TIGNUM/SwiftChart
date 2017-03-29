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
    let items = mockLearnStrategyItems()
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var readMoreItemCount: Int {
        return items.readMoreItems.count
    }

    func readMore(at index: Index) -> LearnStrategyReadMoreItem {
       return items.readMoreItems[index]
    }
}

protocol LearnStrategy {
    var items: [LearnStrategyItem] { get }
    var readMoreItems: [LearnStrategyReadMoreItem] { get }
}

enum LearnStrategyItem {
    case header(localID: String, title: String, subtitle: String)
    case text(localID: String, text: String)
    case video(localID: String, placeholderURL: URL, description: String)
}

enum LearnStrategyReadMoreItem {
    case header(localID: String, title: String, subtitle: String)
    case article(localID: String, title: String, subtitle: String)
}

struct MockLearnStrategy: LearnStrategy {
    let items: [LearnStrategyItem]
    let readMoreItems: [LearnStrategyReadMoreItem]
}

private func mockLearnStrategyItems() -> LearnStrategy {
    return MockLearnStrategy(
        items: mockStrategyItems(),
        readMoreItems: mockReadMore()
    )
}

private func mockStrategyItems() -> [LearnStrategyItem] {
    return [
        .header(localID: UUID().uuidString, title: "OPTIMAL PERFORMANCE STATE", subtitle: "Performance Mindset"),

        .text(localID: UUID().uuidString, text: "Sustainable High Performance is about bringing your best to those critical events that matter most to you. In each of these events, the demands on you and your mindset will be different. In order to optimize your effectiveness you will have to be in your optimal performance state."),

        .video(localID: UUID().uuidString, placeholderURL: URL(string:"https://example.com")!, description: "How to create your optimal performance state (2:26)"),

        .text(localID: UUID().uuidString, text: "In one meeting you may need to be sharp, critical, and driving. In the next meeting you may need to be calm, open, and assessing. When you walk into your house at the end of the day your best emotional state may be serene, loving, and appreciative. Each of these emotional states are different and being caught in the wrong emotional performance state can greatly diminish your chances for success and impact. Through awareness and setting clear intentions you can determine the proper emotional performance state for each event. You can think of this perfect state as a number from 1 to 10 on a slider. Perhaps a 10 would be highly aggressive and assertive and a 1 would be totally passive and assessing. A sales presentation may require you to be a 7.5 to be at your best while a family dinner may require you be at a 4.0. The key is to recognize that every situation is unique and all of us are unique. Some people give their best presentations at a 5 while others are their best at a 9. Once you are clear on where your optimal performance state should be for you and this event the next step is to create it. Two great tools that work for this are ratio breathing and visualization. Ratio breathing refers to the ration of inhalation to exhalation. Breathing in on a count of 4 and exhaling on a count of 4 will represent a balanced middle of the road scale. Increasing your inhalation and shortening your exhalation will move you towards the higher more assertive numbers. Decreasing your inhalation and increasing your exhalation will create more relaxation and serenity. Visualizing yourself in your optimal performance state (connected with the appropriate breathing) is a great way to train your brain to quickly recognize and accept this state. When you do this your brain not only knows what you want, it automatically and unconsciously creates success.")
    ]
}

private func mockReadMore() -> [LearnStrategyReadMoreItem] {
    return [
        .header(localID: UUID().uuidString, title: "Read More", subtitle: "34 Articles"),
        .article(localID: UUID().uuidString, title: "Leverage Stress Benefits", subtitle: "5 Min to read"),
        .article(localID: UUID().uuidString, title: "Off to see the wizard", subtitle: "5:45 to listen"),
        .article(localID: UUID().uuidString, title: "The small change that do", subtitle: "4 min read")
    ]
}
