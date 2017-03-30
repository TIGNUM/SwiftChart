//
//  WhatsHotNewTemplateViewModel.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class WhatsHotNewTemplateViewModel {
    private let sections = [WhatsHotNewTemplateSection]()
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var sectionCount: Int {
        return sections.count
    }

    func numberOfItemsInSection(in section: Int) -> Int {
        return items(in: section).count
    }

    func item(at indexPath: IndexPath) -> WhatsHotNewTemplateItem {
        return items(in: indexPath.section)[indexPath.row]
    }

    private func items(in section: Int) -> [WhatsHotNewTemplateItem] {        
        switch sections[section] {
        case .whatsHotItems(let strategyItems): return strategyItems
        case .readMoreItems(let readMoreItems): return readMoreItems
        case .loadMoreItems(let loadMoreItems): return loadMoreItems
        }
    }
}

private enum WhatsHotNewTemplateSection {
    case whatsHotItems([WhatsHotNewTemplateItem])
    case readMoreItems([WhatsHotNewTemplateItem])
    case loadMoreItems([WhatsHotNewTemplateItem])
}

enum WhatsHotNewTemplateItem {
    case header(localID: String, title: NSAttributedString, subtitle: NSAttributedString, duration: NSAttributedString?)
    case title(localID: String, text: NSAttributedString)
    case subtitle(localID: String, text: NSAttributedString)
    case text(localID: String, text: NSAttributedString)
    case media(localID: String, placeholderURL: URL, description: NSAttributedString)
    case article(localID: String, placeholderURL: URL, title: NSAttributedString, subtitle: NSAttributedString)
    case loadMore(localID: String, placeholderURL: URL, itemNumber: NSAttributedString, title: NSAttributedString, subtitle: NSAttributedString)
}

private func mockWhatsHotNewTemplateItems() -> [WhatsHotNewTemplateSection] {
    return [
        .whatsHotItems(mockWahtsHotItems()),
        .readMoreItems(mockReadMoreItems()),
        .loadMoreItems(mockLoadMoreItems())
    ]
}

private func mockWahtsHotItems() -> [WhatsHotNewTemplateItem] {
    return [
        .header(
            localID: UUID().uuidString,
            title: AttributedString.Learn.WhatsHot.newTemplateHeaderTitle(string: "TIGNUM THOUGHTS"),
            subtitle: AttributedString.Learn.WhatsHot.newTemplateHeaderSubitle(string: "12/01/2017"),
            duration: AttributedString.Learn.WhatsHot.newTemplateHeaderSubitle(string: "5 min read")
        ),

        .title(
            localID: UUID().uuidString,
            text: AttributedString.Learn.WhatsHot.newTemplateTitle(string: "Harness The Power Of Words In Your Life")
        ),

        .text(
            localID: UUID().uuidString,
              text: AttributedString.Learn.WhatsHot.text(string: "In one meeting you may need to be sharp, critical, and driving. In the next meeting you may need to be calm, open, and assessing. When you walk into your house at the end of the day your best emotional state may be serene, loving, and appreciative. Each of these emotional states are different and being caught in the wrong emotional performance state can greatly diminish your chances for success and impact. Through awareness and setting clear intentions you can determine the proper emotional performance state for each event.")
        ),

        .subtitle(
            localID: UUID().uuidString,
            text: AttributedString.Learn.WhatsHot.newTemplateSubtitle(string: "One meeting you may need to be sharp, critical, and driving.")
        ),

        .text(
            localID: UUID().uuidString,
            text: AttributedString.Learn.WhatsHot.text(string: "Once you are clear on where your optimal performance state should be for you and this event the next step is to create it. Two great tools that work for this are ratio breathing and visualization. Ratio breathing refers to the ration of inhalation to exhalation. Breathing in on a count of 4 and exhaling on a count of 4 will represent a balanced middle of the road scale. Increasing your inhalation and shortening your exhalation will move you towards the higher more assertive numbers.")
        ),

        .media(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "htpps://example.com")!,
            description: AttributedString.Learn.WhatsHot.newTemplateMediaDescription(string: "How to create your optimal performance state (2:26)")
        ),

        .text(
            localID: UUID().uuidString,
            text: AttributedString.Learn.WhatsHot.text(string: "In one meeting you may need to be sharp, critical, and driving. In the next meeting you may need to be calm, open, and assessing. When you walk into your house at the end of the day your best emotional state may be serene, loving, and appreciative. Each of these emotional states are different and being caught in the wrong emotional performance state can greatly diminish your chances for success and impact. Through awareness and setting clear intentions you can determine the proper emotional performance state for each event. You can think of this perfect state as a number from 1 to 10 on a slider. Perhaps a 10 would be highly aggressive and assertive and a 1 would be totally passive and assessing. A sales presentation may require you to be a 7.5 to be at your best while a family dinner may require you be at a 4.0. ")
        )
    ]
}

private func mockReadMoreItems() -> [WhatsHotNewTemplateItem] {
    return [
        .header(
            localID: UUID().uuidString,
            title: AttributedString.Learn.headerTitle(string: "Read More"),
            subtitle: AttributedString.Learn.headerSubtitle(string: "34 Articles"),
            duration: nil
        ),

        .article(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            title: AttributedString.Learn.articleTitle(string: "Leverage Stress Benefits"),
            subtitle: AttributedString.Learn.articleSubtitle(string: "5 Min to read")
        ),

        .article(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            title: AttributedString.Learn.articleTitle(string: "Leverage Stress Benefits"),
            subtitle: AttributedString.Learn.articleSubtitle(string: "5 Min to read")
        ),

        .article(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            title: AttributedString.Learn.articleTitle(string: "Leverage Stress Benefits"),
            subtitle: AttributedString.Learn.articleSubtitle(string: "5 Min to read")
        )
    ]
}

private func mockLoadMoreItems() -> [WhatsHotNewTemplateItem] {
    return [
        .header(
            localID: UUID().uuidString,
            title: AttributedString.Learn.headerTitle(string: "Read More"),
            subtitle: AttributedString.Learn.headerSubtitle(string: "34 Articles"),
            duration: nil
        ),

        .loadMore(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            itemNumber: AttributedString.Learn.WhatsHot.identifier(string: "#255"),
            title: AttributedString.Learn.WhatsHot.newTemplateLoadMoreTitle(string: "Don T Let The Outtakes Take You Out"),
            subtitle: AttributedString.Learn.WhatsHot.newTemplateLoadMoreSubtitle(string: "5 Min to read")
        ),

        .loadMore(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            itemNumber: AttributedString.Learn.WhatsHot.identifier(string: "#256"),
            title: AttributedString.Learn.WhatsHot.newTemplateLoadMoreTitle(string: "Don T Let The Outtakes Take You Out"),
            subtitle: AttributedString.Learn.WhatsHot.newTemplateLoadMoreSubtitle(string: "5 Min to read")
        ),

        .loadMore(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            itemNumber: AttributedString.Learn.WhatsHot.identifier(string: "#257"),
            title: AttributedString.Learn.WhatsHot.newTemplateLoadMoreTitle(string: "Don T Let The Outtakes Take You Out"),
            subtitle: AttributedString.Learn.WhatsHot.newTemplateLoadMoreSubtitle(string: "5 Min to read")
        ),

        .loadMore(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            itemNumber: AttributedString.Learn.WhatsHot.identifier(string: "#258"),
            title: AttributedString.Learn.WhatsHot.newTemplateLoadMoreTitle(string: "Don T Let The Outtakes Take You Out"),
            subtitle: AttributedString.Learn.WhatsHot.newTemplateLoadMoreSubtitle(string: "5 Min to read")
        )
    ]
}
