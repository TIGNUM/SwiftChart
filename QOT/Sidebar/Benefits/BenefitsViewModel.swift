//
//  BenefitsViewModel.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class BenefitsViewModel {

    private let items = [BenefitItem]()
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        return items.count
    }

    func item(at indexPath: IndexPath) -> BenefitItem {
        return items[indexPath.row]
    }
}

enum BenefitItem {
    case text(localID: String, title: NSAttributedString, text: NSAttributedString)
    case media(localID: String, placeholderURL: URL, description: String?)
}

private func mockBenefitItems() -> [BenefitItem] {
    return [
        .text(
            localID: UUID().uuidString,
            title: AttributedString.Learn.headerTitle(string: "LOREM IPSUMOP TEXT ONESOIP TWO LINES"),
            text: AttributedString.Learn.headerSubtitle(string: "Lorem ipsum 26 items")
        ),

        .media(
            localID: UUID().uuidString,
            placeholderURL: URL(string:"https://example.com")!,
            description: "How to create your optimal performance state (2:26)"
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Learn.headerTitle(string: "OPTIMAL PERFORMANCE STATE"),
            text: AttributedString.Learn.headerSubtitle(string: "Performance Mindset")
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Learn.headerTitle(string: "OPTIMAL PERFORMANCE STATE"),
            text: AttributedString.Learn.headerSubtitle(string: "Performance Mindset")
        ),

        .media(
            localID: UUID().uuidString,
            placeholderURL: URL(string:"https://example.com")!,
            description: "How to create your optimal performance state (2:26)"
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Learn.headerTitle(string: "OPTIMAL PERFORMANCE STATE"),
            text: AttributedString.Learn.headerSubtitle(string: "Performance Mindset")
        ),
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
