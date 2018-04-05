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

        enum Status {
            case todo
            case done

            var cardColor: UIColor {
                switch self {
                case .done: return .whiteLight6
                case .todo: return .whiteLight12
                }
            }

            var statusViewColor: UIColor {
                switch self {
                case .done: return .charcoalGreyMedium
                case .todo: return .white
                }
            }
        }

        let status: Status
        let title: String
        let content: Content
        let subtitle: String
        let isDailyPrep: Bool
        let link: URL?
        let featureLink: URL?
        let featureButton: String?
        let identifier: String
        let affectsTabBarBadge: Bool

        var isDailyPrepCompleted: Bool {
            return isDailyPrep == true && status == .done
        }
    }

    struct Day {
        var items: [Item]
        var localStartOfDay: Date
    }

    struct Model {

        let days: [Day]
        let greeting: String
        let message: String
    }

    enum Message: Int {

        case welcome = 102978
        case dailyLearnPlan = 102979
        case dailyPrep = 103002
        case guideAllCompleted = 103108
        case guideTodayCompleted = 103107
    }
}

extension Guide.Model: Equatable {

    public static func == (lhs: Guide.Model, rhs: Guide.Model) -> Bool {
        return lhs.days == rhs.days
            && lhs.greeting == rhs.greeting
            && lhs.message == rhs.message
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
            && lhs.featureButton == rhs.featureButton
            && lhs.featureLink == rhs.featureLink
            && lhs.identifier == rhs.identifier
            && lhs.isDailyPrep == rhs.isDailyPrep
            && lhs.isDailyPrepCompleted == rhs.isDailyPrepCompleted
            && lhs.link == rhs.link
            && lhs.status == rhs.status
            && lhs.subtitle == rhs.subtitle
            && lhs.title == rhs.title
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
