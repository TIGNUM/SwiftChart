//
//  GuideModels.swift
//  QOT
//
//  Created by Sam Wyndham on 15.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

struct Guide {

    struct DailyPrepItem {

        let result: Int?
        let resultColor: UIColor
        let title: String
    }

    struct Item {

        enum Content {
            case text(String)
            case dailyPrep(items: [DailyPrepItem], feedback: String?)
        }

        let status: GuideViewModel.Status
        let title: String
        let content: Content
        let subtitle: String
        let type: String
        let link: URL?
        let featureLink: URL?
        let featureButton: String?
        let identifier: String
        let greeting: String
        let createdAt: Date

        var isDailyPrep: Bool {
            return RealmGuideItemNotification.ItemType.morningInterview.rawValue == type ||
                    RealmGuideItemNotification.ItemType.weeklyInterview.rawValue == type
        }

        var isDailyPrepCompleted: Bool {
            return isDailyPrep == true && status == .done
        }
    }

    struct Day {
        var items: [Item]
        var localStartOfDay: Date
    }
}

extension Guide.Day: Equatable {

    public static func == (lhs: Guide.Day, rhs: Guide.Day) -> Bool {
        return lhs.items == rhs.items
            && lhs.localStartOfDay == rhs.localStartOfDay
    }
}

extension Guide.Item: Equatable {

    static func == (lhs: Guide.Item, rhs: Guide.Item) -> Bool {
        return lhs.content == rhs.content
            && lhs.createdAt == rhs.createdAt
            && lhs.featureButton == rhs.featureButton
            && lhs.featureLink == rhs.featureLink
            && lhs.greeting == rhs.greeting
            && lhs.identifier == rhs.greeting
            && lhs.isDailyPrep == rhs.isDailyPrep
            && lhs.isDailyPrepCompleted == rhs.isDailyPrepCompleted
            && lhs.link == rhs.link
            && lhs.status == rhs.status
            && lhs.subtitle == rhs.subtitle
            && lhs.title == rhs.title
            && lhs.type == rhs.type
    }
}

extension Guide.DailyPrepItem: Equatable {

    static func == (lhs: Guide.DailyPrepItem, rhs: Guide.DailyPrepItem) -> Bool {
        return lhs.result == rhs.result
            && lhs.resultColor == rhs.resultColor
            && lhs.title == rhs.title
    }
}

extension Guide.Item.Content: Equatable {

    static func == (lhs: Guide.Item.Content, rhs: Guide.Item.Content) -> Bool {
        switch (lhs, rhs) {
        case let (.text(a), .text(b)):
            return a == b
        case let (.dailyPrep(itemsA, feedbackA), .dailyPrep(itemsB, feedbackB)):
            return itemsA == itemsB && feedbackA == feedbackB
        default:
            return false
        }
    }
}
