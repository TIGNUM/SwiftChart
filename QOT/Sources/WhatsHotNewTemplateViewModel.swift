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
    case loadMore([WhatsHotLoadMoreItem])
}

protocol WhatsHotLoadMoreItem {
    var localID: String { get }
    var placeholderURL: URL { get }
    var itemNumber: NSAttributedString { get }
    var title: NSAttributedString { get }
    var subtitle: NSAttributedString { get }
}

struct MockWhatsHotLoadMoreItem: WhatsHotLoadMoreItem {
    let localID: String
    let placeholderURL: URL
    let itemNumber: NSAttributedString
    let title: NSAttributedString
    let subtitle: NSAttributedString
}

private func mockWhatsHotNewTemplateItems() -> [WhatsHotNewTemplateSection] {
    return [
        .whatsHotItems(mockWahtsHotItems()),
        .readMoreItems(mockReadMoreItems()),
        .loadMoreItems([.loadMore(mockLoadMoreItems())])
    ]
}

private func mockWahtsHotItems() -> [WhatsHotNewTemplateItem] {
    return [
        .header(
            localID: UUID().uuidString,
            title: Style.tag("TIGNUM THOUGHTS", .blackTwo).attributedString(),
            subtitle: Style.secondaryTitle("12/01/2017", .blackTwo).attributedString(),
            duration: Style.secondaryTitle("5 min read", .blackTwo).attributedString()
        ),

        .title(
            localID: UUID().uuidString,
            text: Style.postTitle("Harness The Power Of Words In Your Life", .white).attributedString()
        ),

        .text(
            localID: UUID().uuidString,
              text: Style.headline("In one meeting you may need to be sharp, critical, and driving. In the next meeting you may need to be calm, open, and assessing. When you walk into your house at the end of the day your best emotional state may be serene, loving, and appreciative. Each of these emotional states are different and being caught in the wrong emotional performance state can greatly diminish your chances for success and impact. Through awareness and setting clear intentions you can determine the proper emotional performance state for each event.", .white).attributedString()
        ),

        .subtitle(
            localID: UUID().uuidString,
            text: Style.headline("One meeting you may need to be sharp, critical, and driving.", .white60).attributedString()
        ),

        .text(
            localID: UUID().uuidString,
            text: Style.headline("Once you are clear on where your optimal performance state should be for you and this event the next step is to create it. Two great tools that work for this are ratio breathing and visualization. Ratio breathing refers to the ration of inhalation to exhalation. Breathing in on a count of 4 and exhaling on a count of 4 will represent a balanced middle of the road scale. Increasing your inhalation and shortening your exhalation will move you towards the higher more assertive numbers.", .white).attributedString()
        ),

        .media(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "htpps://example.com")!,
            description: Style.paragraph("How to create your optimal performance state (2:26)", .white60).attributedString()
        ),

        .text(
            localID: UUID().uuidString,
            text: Style.headline("In one meeting you may need to be sharp, critical, and driving. In the next meeting you may need to be calm, open, and assessing. When you walk into your house at the end of the day your best emotional state may be serene, loving, and appreciative. Each of these emotional states are different and being caught in the wrong emotional performance state can greatly diminish your chances for success and impact. Through awareness and setting clear intentions you can determine the proper emotional performance state for each event. You can think of this perfect state as a number from 1 to 10 on a slider. Perhaps a 10 would be highly aggressive and assertive and a 1 would be totally passive and assessing. A sales presentation may require you to be a 7.5 to be at your best while a family dinner may require you be at a 4.0.", .white).attributedString()
        )
    ]
}

private func mockReadMoreItems() -> [WhatsHotNewTemplateItem] {
    return [
        .header(
            localID: UUID().uuidString,
            title: Style.postTitle("Read More", .darkIndigo).attributedString(),
            subtitle: Style.secondaryTitle("34 Articles", .blackTwo).attributedString(),
            duration: nil
        ),

        .article(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            title: Style.headline("Leverage Stress Benefits", .black).attributedString(),
            subtitle: Style.tag("5 Min to read", .blackTwo).attributedString()
        ),

        .article(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            title: Style.headline("Leverage Stress Benefits", .black).attributedString(),
            subtitle: Style.tag("5 Min to read", .blackTwo).attributedString()
        ),

        .article(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            title: Style.headline("Leverage Stress Benefits", .black).attributedString(),
            subtitle: Style.tag("5 Min to read", .blackTwo).attributedString()
        )
    ]
}

private func mockLoadMoreItems() -> [WhatsHotLoadMoreItem] {
    return [
        MockWhatsHotLoadMoreItem(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            itemNumber: Style.headline("#255", .white).attributedString(),
            title: Style.headline("Don`t Let The Outtakes Take You Out", .white).attributedString(),
            subtitle: Style.tag("5 Min to read", .blackTwo).attributedString()
        ),

        MockWhatsHotLoadMoreItem(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            itemNumber: Style.headline("#256", .white).attributedString(),
            title: Style.headline("Don`t Let The Outtakes Take You Out", .white).attributedString(),
            subtitle: Style.tag("5 Min to read", .blackTwo).attributedString()
        ),

        MockWhatsHotLoadMoreItem(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            itemNumber: Style.headline("#257", .white).attributedString(),
            title: Style.headline("Don`t Let The Outtakes Take You Out", .white).attributedString(),
            subtitle: Style.tag("5 Min to read", .blackTwo).attributedString()
        ),

        MockWhatsHotLoadMoreItem(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            itemNumber: Style.headline("#258", .white).attributedString(),
            title: Style.headline("Don`t Let The Outtakes Take You Out", .white).attributedString(),
            subtitle: Style.tag("5 Min to read", .blackTwo).attributedString()
        )
    ]
}
