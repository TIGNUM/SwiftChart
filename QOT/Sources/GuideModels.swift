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
        let key: String
        let title: String
    }

    struct Item {
        enum Content {
            case toBeVision(title: String, body: String, image: URL?)
            case learningPlan(text: String, strategiesCompleted: Int?)
            case dailyPrep(items: [DailyPrepItem], feedback: String?)
			case whatsHotArticle(title: String, body: String, image: URL?)
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
        let isLearningPlan: Bool
        let isWhatsHot: Bool
        let isToBeVision: Bool
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
        case prepNotFinished = 103961
        case learningPlanNotFinished = 103962
        case whatsHotNotFinished1 = 103963
        case whatsHotNotFinished2 = 103964
        case whatsHotNotFinished3 = 103965
        case whatsHotNotFinished4 = 103966
        case toBeVisionNotFinished1 = 103967
        case toBeVisionNotFinished2 = 103968
        case todayFinished1 = 103970
        case todayFinished2 = 103971
    }
}

extension Guide.Model: Equatable {

    public static func == (lhs: Guide.Model, rhs: Guide.Model) -> Bool {
        return lhs.days == rhs.days
            && lhs.message == rhs.message
            && lhs.greeting == rhs.greeting
    }
}

extension Guide.Day: Equatable {

    public static func == (lhs: Guide.Day, rhs: Guide.Day) -> Bool {
        return lhs.localStartOfDay == rhs.localStartOfDay
            && lhs.items == rhs.items
    }
}

extension Guide.Item: Equatable {

    static func == (lhs: Guide.Item, rhs: Guide.Item) -> Bool {
        return lhs.identifier == rhs.identifier
            && lhs.title == rhs.title
            && lhs.link == rhs.link
            && lhs.featureLink == rhs.featureLink
            && lhs.content == rhs.content
            && lhs.subtitle == rhs.subtitle
            && lhs.content == rhs.content
    }
}

extension Guide.DailyPrepItem: Equatable {

    static func == (lhs: Guide.DailyPrepItem, rhs: Guide.DailyPrepItem) -> Bool {
        return lhs.result == rhs.result
            && lhs.key == lhs.key
            && lhs.title == rhs.title
    }
}

extension Guide.Item.Content: Equatable {

    static func == (lhs: Guide.Item.Content, rhs: Guide.Item.Content) -> Bool {
        switch (lhs, rhs) {
        case let (.learningPlan(a), .learningPlan(b)):
            return a == b
        case let (.dailyPrep(itemsA, feedbackA), .dailyPrep(itemsB, feedbackB)):
            return itemsA == itemsB && feedbackA == feedbackB
        default:
            return false
        }
    }
}
